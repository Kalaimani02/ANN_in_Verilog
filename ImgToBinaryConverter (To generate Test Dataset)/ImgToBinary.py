# Convert pixels of an Image to Binary
# Author: P N Kalaimani, Date: Feb 26, 2022
# Dataset Link: https://www.kaggle.com/scolianni/mnistasjpg

from PIL import Image

imgNo = 3
img = Image.open(str(imgNo) +'.jpg').convert('L')  # convert image to 8-bit grayscale
WIDTH, HEIGHT = img.size

f = open('ImgToBinary.txt','w')

data = list(img.getdata()) # convert image data to a list of integers
for num in data:
    f.write(str(format(num,'b')+'\n'))
f.write(str(format(imgNo,'b')))
f.close()