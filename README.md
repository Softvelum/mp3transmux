MP3 Transmuxer prototype
===========

This script goes through MP3 file, calculates frames sizes and total playback time.

> ruby mp3.rb sample.mp3

- sample.mp3 - input MP3 file

Supports MPEG 1, MPEG 2, MPEG 2.5 codecs with full set of Layer 1, Layer 2 and Layer 3.

This is used for prototyping of MP3-to-HLS transmuxing as part of Nimble Streamer server functionality: https://wmspanel.com/nimble
Also, take a look at existing Nimble Streamer VOD feature set: https://wmspanel.com/nimble/vod_streaming


