# LIMBO Analysis
Here are some scripts used for reading data frames, and doing some simple analysis. The file format is described [here](https://github.com/liuweiseu/limbo_recorder/tree/auto_files#file-format).
## lf_rw
We have three m functions in this folder, which are used for read limbo file header and limbo file data.
* prase_pkt_type  
  It's used for prasing file type by checking the filename. If the file name starts with 'Spectra', it means it's a spectra data file; if the file name starts with 'VoltageV2', it means it's a voltage data file.  
  ***Note:*** A filename starting with 'VoltageV1' won't be created in the current design.  

* ReadHeader
It's used for reading the file header, and decode the json format.  
* ReadDataFrame
It's used for reading the data frame, and each data frame contains three parts:   
  * UNIX time
  * Counter value
  * Spectra data or Voltage data
## Analysis functions
* frame_viewer  
  It's used for checking data frame. Only one data frame will be shown each time.
* waterfall  
  It's only used for plotting a waterfall for a spectra data.
* check_loss  
  It shows the UNIX time and Counter value from the data frame, so that we can know if we have packet loss.