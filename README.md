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
		media: .audio // can be `.audio` `.video`
		filters: [youtubedl.InvidiousFilter{
			container: .webm // can be `.webm` `.mp4` `.m4a`
			quality: youtubedl.InvidiousQualityAudio.audio_quality_low
			// quality is a sum type of:
			// - youtubedl.InvidiousQualityAudio
			//    - audio_quality_low
			//    - audio_quality_medium
			// - youtubedl.InvidiousQualityVideo
			//    - q144p
			//    - q240p
			//    - q360p
			//    - q480p
			//    - q720p
			//    - q1080p
		}]
	})!)
}
```
*the url expire after some times*
```v
youtubedl.DownloadInfo{
    title: 'Coldplay - Hymn For The Weekend (Official Video)'
    download_url: 'https://rr5---sn-ab5sznz6.googlevideo.com/videoplayback?expire=1716049248&ei=AIFIZr7uKbq0kucP8_Ov2AI&ip=2001%3A19f0%3A5%3Ac4b%3A3270%3Ab753%3A8168%3Aff6f&id=o-APn7IlFayayIZvN5icOPX7rg984ep5eTuMUDfODsjMqF&itag=249&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&mh=BN&mm=31%2C26&mn=sn-ab5sznz6%2Csn-p5qs7nzk&ms=au%2Conr&mv=m&mvi=5&pl=38&initcwndbps=615000&vprv=1&svpuc=1&mime=audio%2Fwebm&rqh=1&gir=yes&clen=1703040&ratebypass=yes&dur=260.661&lmt=1714508280318617&mt=1716027186&fvip=4&keepalive=yes&c=ANDROID_TESTSUITE&txp=4532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cvprv%2Csvpuc%2Cmime%2Crqh%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=AJfQdSswRgIhAK_TbN0AfHFGh84kn6Ag-03RYOPsOpPNDMCnqjexeBP5AiEA3ePogUr61tUAmnKlepb_Aa70oC0uEqNEc8n6zqDNjPE%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AHWaYeowRQIhALypzX-YsNdNbwzON9moER38YeYrzx9JcUpmAGe3jTD7AiBtG0MUIg1084zKa-ep3WG68aQRk8xWXT-EMprcnRVELA%3D%3D&host=rr5---sn-ab5sznz6.googlevideo.com'
    extension: 'webm'
    length_seconds: 261
}
```
