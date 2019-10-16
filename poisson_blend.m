function imgout = poisson_blend(im_s, mask_s, im_t)
% -----Input
% im_s     source image (object)
% mask_s   mask for source image (1 meaning inside the selected region)
% im_t     target image (background)
% -----Output
% imgout   the blended image

[imh, imw, nb] = size(im_s);
k=imh*imw;
imgout=zeros(imh,imw,nb);
for dim= 1:nb

	s_i=[];
	s_j=[];
	s_v=[];
	B=zeros(k,1);
    B1=zeros(k,1);
	curr=0;
	for i= 1:imh
	    for j=1:imw
            curr=curr+1;
	    	if mask_s(i,j)==0
	    		
                s_i=[s_i curr];
                s_j=[s_j curr];
                s_v=[s_v 1];
	            B(curr)=im_t(i,j,dim);
	        else
	            
	        	extra=0;
                B1(curr)=im_s(i,j,dim);
	            s_i=[s_i curr];
	            s_j=[s_j curr];
	            s_v=[s_v 4];
	        	if mask_s(i,j+1)==0
	        		extra=extra+im_t(i,j+1,dim);
	        	else
	        		s_i=[s_i curr];
		            s_j=[s_j curr+1];
		            s_v=[s_v -1];
	            end
	        	if mask_s(i,j-1)==0
	        		extra=extra+im_t(i,j-1,dim);
	        	else
	        		s_i=[s_i curr];
		            s_j=[s_j curr-1];
		            s_v=[s_v -1];
	            end
	        	if mask_s(i+1,j)==0
	        		extra=extra+im_t(i+1,j,dim);
	        	else
	        		s_i=[s_i curr+imw];
		            s_j=[s_j curr];
		            s_v=[s_v -1];
	            end
	        	if mask_s(i-1,j)==0
	        		extra=extra+im_t(i-1,j,dim);
	        	else
	        		s_i=[s_i curr-imw];
		            s_j=[s_j curr];
		            s_v=[s_v -1];
	            end
	            B(curr)=(4*im_s(i,j,dim)) - im_s(i-1,j,dim) - im_s(i+1,j,dim) - im_s(i,j-1,dim) - im_s(i,j+1,dim) + extra;
	        end
	    end
	end

	A=sparse(s_i,s_j,s_v);
	tmp=1;
	
	solution = A\B;
	error = sum(abs(A*solution-B));
	disp(error)
    
	for i=1:imh
	    for j=1:imw
	        imgout(i,j,dim)=solution(tmp);
	        tmp=tmp+1;
	    end
    end
end

