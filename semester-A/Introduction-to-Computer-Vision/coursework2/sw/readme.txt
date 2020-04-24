There are three main folders containing the corresponding solution for these questions. In each folder of the three main folders, you could run the ICV_Main.m which is the main script to complete the questions.   

For Question 4, the key functions are shown below:
1. [BlockPosCells] = ICV_divideBlocks(inputImage,block_size)
-- divide the image into equally sized non-overlapping block and return the position of each block
2. [block_new_pos] = ICV_blockMatching(block, blockPos,search_window_size,inputImage)
-- match the input block from the previous frame and the block in the next frame, return the position of each matched block


For Question 5, the key functions are shown below:
1. [FrameDifferencing, ThresholdResult] = ICV_TemporalDifference(Frame1,Frame2,Threshold)
-- return the differencing frames and the threshold results

For Question 6, the key functions are shown below:
1. [WindowCells] = ICV_divideWindows(inputImage,num_window_H,num_window_W)
2. [featureDescriptor] = ICV_featureDescriptor(inputLBPblock)
3. [descriptor] = ICV_descriptorOfTheWholeImage(inputImage,num_blocks_H,num_blocks_W)
4. [output, distance1, distance2] = ICV_classifier(labelDescriptor1,labelDescriptor2,sample)
5. [paddingImage] = ICV_boarderMirror(inputImage)

