module youtubedl

pub fn test_get_video_id() {
	assert 'YykjpeuMNEk' == get_video_id('http://youtu.be/YykjpeuMNEk')!
	assert 'YykjpeuMNEk' == get_video_id('http://www.youtube.com/watch?v=YykjpeuMNEk')!
	assert 'YykjpeuMNEk' == get_video_id('http://www.youtube.com/watch?v=YykjpeuMNEk#t=0m10s')!
	assert 'YykjpeuMNEk' == get_video_id('http://www.youtube.com/watch?v=YykjpeuMNEk&feature=feedrec_grec_index')!
	assert 'YykjpeuMNEk' == get_video_id('http://www.youtube.com/v/YykjpeuMNEk?fs=1&amp;hl=en_US&amp;rel=0')!
	assert 'YykjpeuMNEk' == get_video_id('http://www.youtube.com/embed/YykjpeuMNEk?rel=0')!
}
