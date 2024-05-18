module youtubedl

fn test_invidious_get_download() {
	download := invidious_get_download(InvidiousRequest{
		url: 'https://youtu.be/YykjpeuMNEk'
		media: .audio
		filters: [InvidiousFilter{
			container: .webm
			quality: InvidiousQualityAudio.audio_quality_low
		}]
	})!
	assert download.download_url != ''
	assert download.title == 'Coldplay - Hymn For The Weekend (Official Video)'
	assert download.extension == 'webm'
}
