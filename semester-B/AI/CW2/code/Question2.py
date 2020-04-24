# -*- coding: utf-8 -*-
# @Time    : 2020/4/20 8:10 PM
# @Author  : Yinghao Qin
# @Email   : y.qin@hss18.qmul.ac.uk
# @File    : Question2.py
# @Software: PyCharm
# Reference:
#     https://github.com/AbhirajHinge/CNN-with-Fashion-MNIST-dataset


import torchvision
import torchvision.transforms as transforms
import torch
from torch.autograd import Variable
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import matplotlib.pyplot as plt

# data
train_set = torchvision.datasets.FashionMNIST(root = ".", train = True, download = True, transform = transforms.ToTensor())
test_set = torchvision.datasets.FashionMNIST(root = ".", train = False, download = True, transform = transforms.ToTensor())
training_loader = torch.utils.data.DataLoader(train_set, batch_size = 32, shuffle = False)
test_loader = torch.utils.data.DataLoader(test_set, batch_size = 32, shuffle = False)
torch.manual_seed(0)


class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()

        self.conv1 = nn.Conv2d(1, 32, 5)
        self.pool1 = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(32, 64, 5)
        self.pool2 = nn.MaxPool2d(2, 2)
        self.fc1 = nn.Linear(1024, 256)
        self.fc2 = nn.Linear(256, 10)
        # Xavier initialisation
        nn.init.xavier_uniform(self.conv1.weight)
        nn.init.xavier_uniform(self.conv2.weight)

    def forward(self, x):
        x = self.pool1(F.relu(self.conv1(x)))
        x = self.pool2(F.relu(self.conv2(x)))
        # x = self.pool1(F.tanh(self.conv1(x)))
        # x = self.pool2(F.tanh(self.conv2(x)))
        # x = self.pool1(F.sigmoid(self.conv1(x)))
        # x = self.pool2(F.sigmoid(self.conv2(x)))
        # x = self.pool1(F.elu(self.conv1(x)))
        # x = self.pool2(F.elu(self.conv2(x)))
        x = x.view(-1, self.num_flat_features(x))
        x = F.relu(self.fc1(x))
        # x = F.tanh(self.fc1(x))
        # x = F.sigmoid(self.fc1(x))
        # x = F.elu(self.fc1(x))
        # x = F.dropout(x, p=0.3, training=self.training)
        x = self.fc2(x)
        return x

    # flatten the output
    def num_flat_features(self, x):
        size = x.size()[1:]
        num_features = 1
        for s in size:
            num_features *= s
        return num_features


# The statistics for plot the accuracy and loss plot
train_accuracy = []
test_accuracy = []
train_loss = []
test_loss =[]

net = Net().cuda()
num_epochs = 50
criterion = nn.CrossEntropyLoss() # loss function: CrossEntropy
learning_rate = 0.1
optimizer = torch.optim.SGD(net.parameters(), lr=learning_rate) # SGD optimiser

for epoch in range(num_epochs):
    running_loss = 0.0
    print("epoch " + str(epoch))
    for i, (images, labels) in enumerate(training_loader):
        images = Variable(images.cuda())
        labels = Variable(labels.cuda())

        # zeros the parameter gradients
        optimizer.zero_grad()

        # forward + backward + optimize
        outputs = net(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        # In a epoch, all the training data are used to improve the model,
        # and then do statistics i.e, it is time to do statistics
        # when the mini-batches run out
        # Note that len(training_loader) is the number of batches in training data
        if i == len(training_loader) - 1:
            # compute the accuracy and loss for the training data
            correct = 0
            total = 0
            running_loss = 0
            for inputs_, labels_ in training_loader:
                inputs_ = inputs_.cuda()
                labels_ = labels_.cuda()
                outputs_ = net(Variable(inputs_))
                _, predicted = torch.max(outputs_.data, 1)
                total += labels_.size(0)
                correct += (predicted == labels_).sum()

                loss_ = criterion(outputs_, labels_)
                running_loss += loss
            accuracy = ((100.0 * correct) / (total)).item()
            running_loss = (running_loss/len(training_loader)).item()
            print("[Train data] -- Accuracy: " + str(accuracy) + " -- Loss:" + str(running_loss))
            train_accuracy.append(accuracy)
            train_loss.append(running_loss)

            # compute the accuracy and loss for the test data
            correct_test = 0
            total_test = 0
            running_loss_test = 0
            for inputs_, labels_ in test_loader:
                inputs_ = inputs_.cuda()
                labels_ = labels_.cuda()
                outputs_ = net(Variable(inputs_))
                _, predicted = torch.max(outputs_.data, 1)
                total_test += labels_.size(0)
                correct_test += (predicted == labels_).sum()

                loss_ = criterion(outputs_, labels_)
                running_loss_test += loss_
            accuracy_test = ((100.0 * correct_test) / (total_test)).item()
            running_loss_test = (running_loss_test/len(test_loader)).item()
            print("[Test data]  -- Accuracy: " + str(accuracy_test) + " -- Loss:" + str(running_loss_test))
            test_accuracy.append(accuracy_test)
            test_loss.append(running_loss_test)

print("The final accuracy on train set is:" + str(train_accuracy[-1]))
print("The final accuracy on test set is:" + str(test_accuracy[-1]))
#########################################################
# plot the accuracy and loss images
x = np.linspace(1,num_epochs,num_epochs,endpoint=True)
plt.plot(x, train_accuracy, color='r', label='Train_accuracy')
plt.plot(x, test_accuracy, color='b', label='Test_accuracy')
plt.legend()
plt.title('Accuracy against epoch in the train and test sets')
plt.xlabel('Epoch')
plt.ylabel('Accuracy(%)')
path = 'results/accuracy_epoch.png'
plt.savefig(path)
plt.show()

plt.plot(x, train_loss, color='r', label='Train_loss')
plt.plot(x, test_loss, color='b', label='Test_loss')
plt.legend()
plt.title('Loss against epoch in the train and test sets')
plt.xlabel('Epoch')
plt.ylabel('Loss')
path = 'results/loss_epoch.png'
plt.savefig(path)
plt.show()
plt.close()
