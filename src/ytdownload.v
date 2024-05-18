module youtubedl

import net.http
import json
import time

pub enum YtDownloadFtype {
	mp3
	mp4
	webm
}

pub fn (ftype YtDownloadFtype) str() string {
	return match ftype {
		.mp3 { 'mp3' }
		.mp4 { 'mp4' }
		.webm { 'webm' }
	}
}

pub struct YtDownloadRequestId {
pub:
	ftype YtDownloadFtype @[required]
	url   string          @[required]
}

struct YtDownloadRequestIdResponse {
	extractor      string
	video_id       string          @[json: videoId]
	title          string
	length_seconds string          @[json: lengthSeconds]
	tasks          []struct {
		quality_label string @[json: qualityLabel]
		hash          string
	}
}

struct YtDownloadStartDownload {
	hash string
}

struct YtDownloadStartDownloadResponse {
	task_id string @[json: taskId]
}

struct YtDownloadCheckStatus {
	task_id string @[json: taskId]
}

struct YtDownloadCheckStatusResponse {
	task_id           string @[json: taskId]
	status            string
	download_progress int
	convert_progress  int
	title             string
	ext               string
	video_id          string @[json: videoId]
	download          string
}

pub fn ytdownload_get_download(request YtDownloadRequestId) !DownloadInfo {
	all_options_resp := http.fetch(http.FetchConfig{
		url: 'http://yt-download.org/api/json'
		method: http.Method.post
		header: http.new_header_from_map({
			http.CommonHeader.content_type: 'application/json'
			http.CommonHeader.accept:       'application/json'
		})
		data: json.encode(request)
	})!
	all_options := json.decode(YtDownloadRequestIdResponse, all_options_resp.body)!
	if all_options.tasks.len == 0 {
		return error('Could not find the video')
	}
	task_id_resp := http.fetch(http.FetchConfig{
		url: 'http://yt-download.org/api/json'
		method: http.Method.post
		header: http.new_header_from_map({
			http.CommonHeader.content_type: 'application/json'
			http.CommonHeader.accept:       'application/json'
		})
		data: json.encode(YtDownloadStartDownload{
			hash: all_options.tasks[0].hash
		})
	})!
	task_id := json.decode(YtDownloadStartDownloadResponse, task_id_resp.body)!
	for {
		time.sleep(1)
		download_resp := http.fetch(http.FetchConfig{
			url: 'http://yt-download.org/api/json/task'
			method: http.Method.post
			header: http.new_header_from_map({
				http.CommonHeader.content_type: 'application/json'
				http.CommonHeader.accept:       'application/json'
			})
			data: json.encode(YtDownloadCheckStatus{
				task_id: task_id.task_id
			})
		})!
		download := json.decode(YtDownloadCheckStatusResponse, download_resp.body) or { continue }
		if download.download_progress == 100 && download.convert_progress == 100
			&& download.download != '' {
			return DownloadInfo{
				title: download.title
				download_url: download.download
				extension: download.ext
				length_seconds: all_options.length_seconds.int()
			}
		}
	}
	return error('This should not happen')
}
