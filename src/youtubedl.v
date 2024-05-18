module youtubedl

import net.urllib

pub struct DownloadInfo {
pub:
	title          string
	download_url   string
	extension      string
	length_seconds int
}

pub fn get_video_id(url_url string) !string {
	url := urllib.parse(url_url)!
	if url.path.starts_with('/watch') {
		return urllib.parse_query(url.raw_query)!.get('v') or { error('Could not find video id') }
	}
	if url.path.starts_with('/v') || url.path.starts_with('/embed') {
		return url.path.trim('/').split('/')[1]
	}
	return url.path.trim('/')
}
