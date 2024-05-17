module youtubedl

fn test_get_download() {
	download := ytdownload_get_download(YtDownloadRequestId{
		ftype: .mp3
		url: 'https://www.youtube.com/watch?v=YykjpeuMNEk'
	})!
	assert download.download_url != ''
	assert download.title == 'Coldplay - Hymn For The Weekend (Official Video)'
	assert download.extension == 'mp3'
}
