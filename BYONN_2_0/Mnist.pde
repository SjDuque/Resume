import java.util.*;
import java.io.*;
import java.util.zip.GZIPInputStream;

class Mnist{
  ReadFiles trainImages;
  ReadFiles trainLabels;
  ReadFiles testImages;
  ReadFiles testLabels;
  int mTrain;
  int mTest;
  int rows; //this is the reduced rows
  int cols; //this is the reduced columns

  Mnist() throws IOException{ // this loads up the mnist database
    trainImages = new ReadFiles(sketchPath() + "/train-images.gz",1);
    trainLabels = new ReadFiles(sketchPath() + "/train-labels.gz");
    testImages = new ReadFiles(sketchPath()  + "/test-images.gz",1);
    testLabels = new ReadFiles(sketchPath() + "/test-labels.gz");
    mTrain = trainImages.m;
    mTest = testImages.m;
    rows = testImages.rows; //this is so that I can reduce the number of features
    cols = testImages.cols; //this is so that I can reduce the number of features
  }
  float [] nextTrainImage() throws IOException{
    return trainImages.nextImage();
  }
  float [] nextTestImage() throws IOException{
    return testImages.nextImage();
  }
  float [] nextTrainLabel() throws IOException{
    return trainLabels.nextLabel();
  }
  float [] nextTestLabel() throws IOException{
    return testLabels.nextLabel();
  }
  
  
  
}
class ReadFiles{
  DataInputStream input;
  int magicNumber;
  int m;
  int rows; //desired number of rows
  int cols; //desired number of rows
  int actualRows; //this is the rows from the mnist data
  int actualCols; //this is the cols from the mnist data
  ReadFiles(String dir, int i) throws IOException{
    input = new DataInputStream(new GZIPInputStream(new FileInputStream(dir)));
    magicNumber = input.readInt();
    m = input.readInt();//total number of inputs
    actualRows = input.readInt();
    actualCols = input.readInt();
    
    rows = desiredRows;
    cols = desiredCols;
  }
  ReadFiles(String dir)throws IOException{
    input = new DataInputStream(new GZIPInputStream(new FileInputStream(dir)));
    magicNumber = input.readInt();
    m = input.readInt();
  }
  float[] nextImage() throws IOException{
    float[] image = new float[rows*cols];
    //int actualLength = actualRows*actualCols;
    int rDif = (actualRows - rows)/2;
    int cDif = (actualCols - cols)/2;
    for(int c = 0; c < actualRows; c ++){
      for(int r = 0; r < actualCols; r++){
        float pixel = (float)input.readUnsignedByte()/255.0;
        if(r-rDif + 1 > 0 && r + rDif < actualRows && c-cDif + 1 > 0 && c + cDif < actualCols){
          int index = (r-rDif)*cols+(c-cDif);
          image[index] = pixel;
        }
      }
    }
    return image;
  }
  float[] nextLabel() throws IOException{
    int label = input.readUnsignedByte();
    float[] y = new float[10];
    //freq[label] += 1;
    y[label] = 1;
    return y;
  }
}
