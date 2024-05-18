# Youtubedl

Download audio/video from web site url

## Install

```bash
v install Saverio976.youtubedl
```

## Usage

### https://www.yt-download.org

```v
import saverio976.youtubedl

fn main() {
	// this use https://www.yt-download.org json api
	println(youtubedl.ytdownload_get_download(youtubedl.YtDownloadRequestId{
		ftype: .mp3 // can be `.mp4` `.webm` `.mp3`
		url: 'https://www.youtube.com/watch?v=YykjpeuMNEk'
	})!)
}
```
*the url expire after some times*
```v
ytdownload.DownloadInfo{
    title: 'Coldplay - Hymn For The Weekend (Official Video)'
    download_url: 'http://yt-download.org/dl?hash=QQsj9Xb%2BSpmuaTSMpF3t4lHON6I8IBwYvE1T0utgI6hnAlM0Ip7Cz%2BiFxBXf7Vmm5t%2F
rzncW1MBLQC3FBWKHgqpiDpcWUyKx9877XZTkqwM1CuoJ0E2S4peYT%2BZkzv6eH2%2FHgAQ%2FlFK7csAFPg8%2FxaDTwEb9L9vsVCLbqTsiD3hIYlR2qkbCkW
jsVpzpf011Cg4w5YjVjnOpEtCR1D11llfDpKUAkUmeOVeUGSkzIJo%3D'
    extension: 'mp3'
    length_seconds: 261
}
```

### https://invidious.io

```v
import saverio976.youtubedl

fn main() {
	println(youtubedl.invidious_get_download(youtubedl.InvidiousRequest{
		// invidious_instance_url: 'https://yt.artemislena.eu' // You can specify an instance, or let the module iterate over all known instances
		url: 'https://youtu.be/YykjpeuMNEk'
		media: .audio
		filters: [youtubedl.InvidiousFilter{
			container: .webm
			quality: youtubedl.InvidiousQualityAudio.audio_quality_low
		}]
	})!)
}
```
*the url expire after some times*
```v

```
