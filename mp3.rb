#
# Provided by WMSPanel.com team
# Author: Alex Pokotilo
# Contact: support@wmspanel.com
#

p "wrong parameter count. add only mpeg2ts input filename" and exit if ARGV.length == 0


MPEG_VERSION = [
    'MPEG 2.5',   # 0
    'NOT USED',   # 1
    'MPEG 2',     # 2
    'MPEG 1'      # 3
].freeze

MPEG_LAYER = [
      'NOT USED',  # 0
      'Layer 3',   # 1
      'Layer 2',   # 2
      'Layer 1'    # 3
].freeze

=begin

Bitrate Index         	MPEG 1	                    MPEG 2, 2.5 (LSF)
                  Layer I	Layer II	Layer III	  Layer I	   Layer II & III
0000	                               free
0001	               32	     32	      32	           32	   8
0010	               64	     48	      40	           48    16
0011	               96	     56	      48	           56	   24
0100	              128	     64	      56	           64	   32
0101	              160	     80	      64	           80	   40
0110	              192	     96	      80	           96	   48
0111	              224	    112	      96	          112	   56
1000	              256	    128	     112	          128	   64
1001	              288	    160	     128	          144	   80
1010	              320	    192	     160	          160	   96
1011	              352	    224	     192	          176	  112
1100	              384	    256	     224	          192	  128
1101	              416	    320	     256	          224	  144

1110	              448	    384	     320	          256	  160
1111	                              reserved
=end



MPEG_BIT_RATE = [
  #          MPEG 2.5                     INVALID                       MPEG2                        MPEG1

      #INVALID  L3   L2  L1            INVALID  L3   L2  L1         INVALID  L3   L2  L1         INVALID  L3   L2  L1
  [   [0,       0,         0,      0],        [ 0,       0,   0,  0 ],      [0,          0,      0,      0],     [ 0,           0,      0,       0]   ], # 0000
  [   [0,       8000,   8000,  32000],        [ 0,       0,   0,  0 ],      [0,       8000,   8000,  32000],     [ 0,       32000,  32000,   32000]   ], # 0001
  [   [0,      16000,  16000,  48000],        [ 0,       0,   0,  0 ],      [0,      16000,  16000,  48000],     [ 0,       40000,  48000,   64000]   ], # 0010
  [   [0,      24000,  24000,  56000],        [ 0,       0,   0,  0 ],      [0,      24000,  24000,  56000],     [ 0,       48000,  56000,   96000]   ], # 0011
  [   [0,      32000,  32000,  64000],        [ 0,       0,   0,  0 ],      [0,      32000,  32000,  64000],     [ 0,       56000,  64000,  128000]   ], # 0100
  [   [0,      40000,  40000,  80000],        [ 0,       0,   0,  0 ],      [0,      40000,  40000,  80000],     [ 0,       64000,  80000,  160000]   ], # 0101
  [   [0,      48000,  48000,  96000],        [ 0,       0,   0,  0 ],      [0,      48000,  48000,  96000],     [ 0,       80000,  96000,  192000]   ], # 0110
  [   [0,      56000,  56000, 112000],        [ 0,       0,   0,  0 ],      [0,      56000,  56000, 112000],     [ 0,       96000,  112000, 224000]   ], # 0111
  [   [0,      64000,  64000, 128000],        [ 0,       0,   0,  0 ],      [0,      64000,  64000, 128000],     [ 0,      112000,  128000, 256000]   ], # 1000
  [   [0,      80000,  80000, 144000],        [ 0,       0,   0,  0 ],      [0,      80000,  80000, 144000],     [ 0,      128000,  160000, 288000]   ], # 1001
  [   [0,      96000,  96000, 160000],        [ 0,       0,   0,  0 ],      [0,      96000,  96000, 160000],     [ 0,      160000,  192000, 320000]   ], # 1010
  [   [0,     112000, 112000, 176000],        [ 0,       0,   0,  0 ],      [0,     112000, 112000, 176000],     [ 0,      192000,  224000, 352000]   ], # 1011
  [   [0,     128000, 128000, 192000],        [ 0,       0,   0,  0 ],      [0,     128000, 128000, 192000],     [ 0,      224000,  256000, 384000]   ], # 1100
  [   [0,     144000, 144000, 224000],        [ 0,       0,   0,  0 ],      [0,     144000, 144000, 224000],     [ 0,      256000,  320000, 416000]   ], # 1101
  [   [0,     160000, 160000, 256000],        [ 0,       0,   0,  0 ],      [0,     160000, 160000, 256000],     [ 0,      320000,  384000, 448000]   ], # 1110
  [   [0,          0,      0,      0],        [ 0,       0,   0,  0 ],      [0,          0,      0,      0],     [ 0,        0,          0,      0]   ]  # 1111
].freeze


=begin
                                       MPEG Versions and Sampling Rates

Sampling Rate Index	                  MPEG 1  	 MPEG 2 (LSF)	MPEG 2.5 (LSF)
00	                                  44100Hz	   22050Hz	    11025Hz
01	                                  48000Hz	   24000Hz	    12000Hz
10	                                  32000Hz	   16000Hz	    8000Hz
11	                                        reserved
=end


MPEG_SAMPLING_RATES= [
    #MPEG2.5   #INVALID  MPEG 2   MPEG 1
    [11025,    0,        22050,   44100], # 00
    [12000,    0,        24000,   48000], # 01
    [8000 ,    0,        16000,   32000], # 10
    [0,        0,           0,        0]  # 11
].freeze

=begin
                Samples Per Frame

            MPEG 1	   MPEG 2 (LSF)	 MPEG 2.5 (LSF)
Layer I	      384	             384	   384
Layer II	    1152	          1152	  1152
Layer III	    1152	           576	   576
=end

MPEG_SAMPLES_PER_FRAME=[
    # MPEG 2.5
             #INVALID   L3   L2    L1
             [0,       576, 1152, 384],
    # INVALID
             [0,       0,    0,    0],
    # MPEG 2
             [0,       576, 1152, 384],
    # MPEG 1
             [0,       1152, 1152, 384],
].freeze


def processMP3File(buffer)
  offset = 0;
  if (buffer[0] == 0x49 && buffer[1] == 0x44 && buffer[2] == 0x33)
     size = (buffer[6] << 21) |
            (buffer[7] << 14) |
            (buffer[8] << 7)  |
            (buffer[9]);
    offset+= size + 10
    p "ID3 tag found. offset is #{offset}"
  end


  mpeg_version_index = -1
  layer_index = -1
  sampling_rate_index = -1

  duration_samples = 0
  while offset + 4 < buffer.size  do
    # lets find header

    if buffer[offset] == 0xFF && ((buffer[offset + 1] & 0xE0) == 0xE0)

      mpeg_version_index_current = (buffer[offset + 1] >> 3) & 0b11
      if mpeg_version_index_current == 1
        offset+=1
        p "missed hedaer"
        next
      end

      if mpeg_version_index == -1
        mpeg_version_index = mpeg_version_index_current
      end

      if mpeg_version_index_current != mpeg_version_index
        offset+=1
        p "missed hedaer"
        next
      end

      layer_index_current      = (buffer[offset + 1] >> 1) & 0b11
      if layer_index == -1
        layer_index = layer_index_current
      end

      if layer_index_current != layer_index
        offset+=1
        p "missed hedaer"
        next
      end

      protection_bit = buffer[offset + 1] & 0b1

      bitrate_index            = (buffer[offset + 2] >> 4) & 0b1111
      sampling_rate_index_current  = (buffer[offset + 2] >> 2) & 0b11

      if sampling_rate_index == -1
        sampling_rate_index = sampling_rate_index_current
      end

      if sampling_rate_index != sampling_rate_index_current
        offset+=1
        p "missed hedaer"
        next
      end

      padding_bit      = (buffer[offset + 2] >> 1) & 0b1

      samples_per_frame = MPEG_SAMPLES_PER_FRAME[mpeg_version_index][layer_index]
      bitrate = MPEG_BIT_RATE[bitrate_index][mpeg_version_index][layer_index]
      sampling_rate = MPEG_SAMPLING_RATES[sampling_rate_index_current][mpeg_version_index]

      # slot is 4 for layer 1 and 1 for the rest
      slot = layer_index_current == 3 ? 4 : 1

                   # 4 is MPEG header size
      if layer_index_current == 3 # Layer 1
        frame_size = (12 * bitrate / sampling_rate + (padding_bit==1 ? slot : 0 )) * 4
      else # Layer 2, 3
        frame_size = 144 * bitrate / sampling_rate + (padding_bit==1 ? slot : 0 )
      end

      frame_size+= (protection_bit ? 0 : 2)

      p "#{MPEG_VERSION[mpeg_version_index]} #{MPEG_LAYER[layer_index]} BR=#{bitrate_index} FR=#{sampling_rate_index_current} FS=#{frame_size}"
      offset+= frame_size

      duration_samples += samples_per_frame

    else
      offset+=1
    end
  end

  duration = duration_samples / sampling_rate
  p "composition duration is #{duration}"
end

File.open ARGV[0], 'rb' do |file|
  file_size = file.size
  buffer = (file.read(file_size).unpack 'C*')
  processMP3File(buffer)
end
