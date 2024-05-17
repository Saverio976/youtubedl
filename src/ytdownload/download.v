module ytdownload

import net.http
import json
import time

pub enum Ftype {
	mp3
	mp4
	webm
}

pub fn (ftype Ftype) str() string {
	return match ftype {
		.mp3 { 'mp3' }
		.mp4 { 'mp4' }
		.webm { 'webm' }
	}
}

pub struct RequestId {
pub:
	ftype string @[required]
	url   string @[required]
}

struct RequestIdResponse {
	extractor      string
	video_id       string          @[json: videoId]
	title          string
	length_seconds string          @[json: lengthSeconds]
	tasks          []struct {
		quality_label string @[json: qualityLabel]
		hash          string
	}
}

struct StartDownload {
	hash string
}

struct StartDownloadResponse {
	task_id string @[json: taskId]
}

struct CheckStatus {
	task_id string @[json: taskId]
}

struct CheckStatusResponse {
	task_id           string @[json: taskId]
	status            string
	download_progress int
	convert_progress  int
	title             string
	ext               string
	video_id          string @[json: videoId]
	download          string
}

pub struct DownloadInfo {
pub:
	title string
	download_url string
	extension string
	length_seconds int
}

pub fn get_download(request RequestId) !DownloadInfo {
	all_options_resp := http.fetch(http.FetchConfig{
		url: 'http://yt-download.org/api/json'
		method: http.Method.post
		header: http.new_header_from_map({
			http.CommonHeader.content_type: 'application/json'
			http.CommonHeader.accept:       'application/json'
		})
		data: json.encode(request)
	})!
	all_options := json.decode(RequestIdResponse, all_options_resp.body)!
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
		data: json.encode(StartDownload{
			hash: all_options.tasks[0].hash
		})
	})!
	task_id := json.decode(StartDownloadResponse, task_id_resp.body)!
	for {
		time.sleep(1)
		download_resp := http.fetch(http.FetchConfig{
			url: 'http://yt-download.org/api/json/task'
			method: http.Method.post
			header: http.new_header_from_map({
				http.CommonHeader.content_type: 'application/json'
				http.CommonHeader.accept:       'application/json'
			})
			data: json.encode(CheckStatus{
				task_id: task_id.task_id
			})
		})!
		download := json.decode(CheckStatusResponse, download_resp.body) or { continue }
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
