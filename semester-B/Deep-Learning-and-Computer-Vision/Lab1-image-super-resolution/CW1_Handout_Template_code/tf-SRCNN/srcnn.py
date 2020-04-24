import time
import os
import matplotlib.pyplot as plt

import numpy as np
import tensorflow as tf
import scipy
import pdb
import skimage
from scipy import misc

def imread(path, is_grayscale=True):
  """
  Read image using its path.
  Default value is gray-scale, and image is read by YCbCr format as the paper said.
  """
  if is_grayscale:
    return scipy.misc.imread(path, flatten=True, mode='YCbCr').astype(np.float)
  else:
    return scipy.misc.imread(path, mode='YCbCr').astype(np.float)

def modcrop(image, scale=3):
  """
  To scale down and up the original image, first thing to do is to have no remainder while scaling operation.
  
  We need to find modulo of height (and width) and scale factor.
  Then, subtract the modulo from height (and width) of original image size.
  There would be no remainder even after scaling operation.
  """
  if len(image.shape) == 3:
    h, w, _ = image.shape
    h = h - np.mod(h, scale)
    w = w - np.mod(w, scale)
    image = image[0:h, 0:w, :]
  else:
    h, w = image.shape
    h = h - np.mod(h, scale)
    w = w - np.mod(w, scale)
    image = image[0:h, 0:w]
  return image

def preprocess(path, scale=3):
  """
  Preprocess single image file 
    (1) Read original image as YCbCr format (and grayscale as default)
    (2) Normalize
    (3) Apply image file with bicubic interpolation
  Args:
    path: file path of desired file
    input_: image applied bicubic interpolation (low-resolution)
    label_: image with original resolution (high-resolution)
  """
  image = imread(path, is_grayscale=True)
  label_ = modcrop(image, scale)

  # Must be normalized
  image = image / 255.
  label_ = label_ / 255.

  # To shrink the image by 3 times with bicubic interpolation algorithm
  input_ = scipy.ndimage.interpolation.zoom(label_, (1./scale), prefilter=False)
  input_ = scipy.ndimage.interpolation.zoom(input_, (scale/1.), prefilter=False)
  # pdb.set_trace()
  # plt.imshow(input_,cmap='gray')
  # ply.show()

  return input_, label_

"""Set the image hyper parameters
"""
c_dim = 1
input_size = 255

"""Define the model weights and biases 
"""

# define the placeholders for inputs and outputs
# The four parameters denote batch, height, width, and channel respectively
inputs = tf.placeholder(tf.float32, [None, input_size, input_size, c_dim], name='inputs')

## ------ Add your code here: set the weight of three conv layers
# replace '0' with your hyper parameter numbers 
# conv1 layer with biases: 64 filters with size 9 x 9
# conv2 layer with biases and relu: 32 filters with size 1 x 1
# conv3 layer with biases and NO relu: 1 filter with size 5 x 5
weights = {
    'w1': tf.Variable(tf.random_normal([9, 9, 1, 64], stddev=1e-3), name='w1'),
    'w2': tf.Variable(tf.random_normal([1, 1, 64, 32], stddev=1e-3), name='w2'),
    'w3': tf.Variable(tf.random_normal([5, 5, 32, 1], stddev=1e-3), name='w3')
    }

biases = {
      'b1': tf.Variable(tf.zeros([64]), name='b1'),
      'b2': tf.Variable(tf.zeros([32]), name='b2'),
      'b3': tf.Variable(tf.zeros([1]), name='b3')
    }

"""Define the model layers with three convolutional layers
"""
## ------ Add your code here: to compute feature maps of input low-resolution images
# replace 'None' with your layers: use the tf.nn.conv2d() and tf.nn.relu()
# conv1 layer with biases and relu : 64 filters with size 9 x 9

conv1 = tf.nn.conv2d(inputs, weights['w1'], strides=[1, 1, 1, 1], padding='SAME')
conv1 = tf.nn.bias_add(conv1, biases['b1'])
conv1 = tf.nn.relu(conv1)
##------ Add your code here: to compute non-linear mapping
# conv2 layer with biases and relu: 32 filters with size 1 x 1

conv2 = tf.nn.conv2d(conv1, weights['w2'], strides=[1, 1, 1, 1], padding='SAME')
conv2 = tf.nn.bias_add(conv2, biases['b2'])
conv2 = tf.nn.relu(conv2)
##------ Add your code here: compute the reconstruction of high-resolution image
# conv3 layer with biases and NO relu: 1 filter with size 5 x 5
conv3 = tf.nn.conv2d(conv2, weights['w3'], strides=[1, 1, 1, 1], padding='SAME')
conv3 = tf.nn.bias_add(conv3, biases['b3'])


"""Load the pre-trained model file
"""
model_path='./model/model.npy'
model = np.load(model_path, encoding='latin1', allow_pickle=True).item()

##------ Add your code here: show the weights of model and try to visualisa
# show the weights of the layer 1
fig1 = plt.figure(figsize=(16,16))
fig1.suptitle('Layer 1: The weights of all 64 filters at channel 0')
fig1.subplots_adjust(hspace=1.0, wspace=1.0)
for i in range(1,65):
    ax = fig1.add_subplot(8,8,i)
    ax.plot(model['w1'][:,:,0,i-1],marker='*',linestyle='dashed')
fig1.savefig('weights_of_layer1.png',dpi=fig1.dpi)
# fig1.show()

# show the weights of the layer 2
fig2 = plt.figure(figsize=(16,16))
fig2.suptitle('Layer 2: The weights of all 32 filters at channel 0')
fig2.subplots_adjust(hspace=0.4, wspace=0.4)
for i in range(1,33):
    ax = fig2.add_subplot(4,8,i)
    ax.plot(model['w2'][:,:,0,i-1], marker='*',linestyle='dashed')
fig2.savefig('weights_of_layer2.png',dpi=fig2.dpi)
# fig2.show()

# show the weights of the output layer
fig3 = plt.figure()
fig3.suptitle('Layer 3: The weights of the only filter at channel 0')
ax = fig3.add_subplot(1,1,1)
ax.plot(model['w3'][:,:,0,0], marker='*',linestyle='dashed')
fig3.savefig('weights_of_layer3.png',dpi=fig3.dpi)
# plt.show()

"""Initialize the model variabiles (w1, w2, w3, b1, b2, b3) with the pre-trained model file
"""
# launch a session
config = tf.ConfigProto()
config.gpu_options.allow_growth = True
config.gpu_options.per_process_gpu_memory_fraction = 0.9
sess = tf.Session(config=config)

for key in weights.keys():
  sess.run(weights[key].assign(model[key]))

for key in biases.keys():
  sess.run(biases[key].assign(model[key]))
# pdb.set_trace()
# model['w1'][:, :, 0, 0]
# exercise
# 2.2
# model['w1'][:,:,0,0]
# model['b1'][9]
# 2.3
# model['w2'][:,:,0,4]
# model['b2'][5]
# model['w2'][0,0,:,0].shape
# 2.4
# model['w3'][:,:,0,0]
# model['b3'][0]

"""Read the test image
"""
blurred_image, groudtruth_image = preprocess('./image/butterfly_GT.bmp')

"""Run the model and get the SR image
"""
# transform the input to 4-D tensor
input_ = np.expand_dims(np.expand_dims(blurred_image, axis=0), axis=-1)

# run the session
# here you can also run to get feature map like 'conv1' and 'conv2'
feature_map_1 = sess.run(conv1, feed_dict={inputs: input_})
feature_map_2 = sess.run(conv2, feed_dict={inputs: input_})
ouput_ = sess.run(conv3, feed_dict={inputs: input_})
# pdb.set_trace()

##------ Add your code here: save the blurred and SR images and compute the psnr
# hints: use the 'scipy.misc.imsave()'  and ' skimage.measuse.compare_psnr()'

ouput_ = np.reshape(ouput_, (255, 255))

scipy.misc.imsave('feature_map_1.png',feature_map_1[0,:,:,0])
scipy.misc.imsave('feature_map_2.png',feature_map_2[0,:,:,0])
scipy.misc.imsave('gt.png',groudtruth_image)
scipy.misc.imsave('blurred.png',blurred_image)
scipy.misc.imsave('output.png', ouput_)

# f = plt.figure()
# f, axarr = plt.subplots(3,1)
# axarr[0].imshow(groudtruth_image, cmap='gray')
# axarr[1].imshow(blurred_image, cmap='gray')
# axarr[2].imshow(ouput_,cmap='gray')
# plt.show()

# pdb.set_trace()
print(skimage.measure.compare_psnr(groudtruth_image, ouput_, data_range=1))
print(skimage.measure.compare_psnr(groudtruth_image, blurred_image, data_range=1))