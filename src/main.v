module main

import ytdownload

fn main() {
	println(ytdownload.get_download(ytdownload.RequestId{
		ftype: 'mp3'
		url: 'https://www.youtube.com/watch?v=YykjpeuMNEk'
	})!)
}
