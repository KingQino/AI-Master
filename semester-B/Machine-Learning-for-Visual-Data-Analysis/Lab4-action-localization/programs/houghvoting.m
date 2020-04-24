function hough_array = houghvoting(patches,position,spa_scale,tem_scale,frame_num,flag_mat,struct_cb)
% hough_array           : is a matrix with 7 rows, each column indicating the
%                       : predicted(votes) spatial location, predicted (voted) start and end frames,
%                       : the votes, bounding box values(scale compensated). Example: Let a descriptor matched with
%                       : the codeword (with one offset) cast votes at the spatial location [x,y],
%                       : temporal location [s,e] (predictions for start and end frames), bounding box values [b1 b2] (stored during training)
%                       : with value(weight) 'v', then corresponding column in the
%                       : matrix hough_array will be [x y s e v b1 b2]'.
% patches               : i/p descriptors
% position              : spatial location of the detected STIP                   
% spa_scale             : spatial scale                      
% tem_scale             : temporal scale
% frame_num             : frame number at which STIP was detected
% flag_mat              : refer to ism_test_voting.m
  
%-----------------------------------------------------------------------------------------------------
% Write your code here to compute the matrix hough_array
%-----------------------------------------------------------------------------------------------------
hough_array = [];

% cast the votes
for i = 1:size(patches,2)
    match_codeword_list = find(flag_mat(:,i)==1);
    for j = 1:size(match_codeword_list,1)
        
        match_codeword = match_codeword_list(j);
        for k = 1:struct_cb.offset(match_codeword).tot_cnt
            % set the vote location
            x = position(1,i) - struct_cb.offset(match_codeword).spa_offset(1,k) * spa_scale(i);
            y = position(2,i) - struct_cb.offset(match_codeword).spa_offset(2,k) * spa_scale(i);
            
            % set the start and end frame
            s = frame_num(i) - struct_cb.offset(match_codeword).st_end_offset(1,k) * tem_scale(i);
            e = frame_num(i) - struct_cb.offset(match_codeword).st_end_offset(2,k) * tem_scale(i);
            s = round(s);
            e = round(e);
            
            % set the vote weight 
            match_weight = 1/size(match_codeword_list,1);
            occurrence_weight = 1/struct_cb.offset(match_codeword).tot_cnt;
            v = match_weight * occurrence_weight;
            
            % set the bounding box
            b1 = struct_cb.offset(match_codeword).hei_wid_bb(1,k)*spa_scale(i);
            b2 = struct_cb.offset(match_codeword).hei_wid_bb(2,k)*spa_scale(i);
            b1 = round(b1);
            b2 = round(b2);
            
            hough_one_vote = [x y s e v b1 b2]';
            hough_array = [hough_array hough_one_vote];
            
        end
                 
    end
end

end