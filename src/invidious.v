module youtubedl

import net.http
import json

const invidious_instances = [
	'https://yewtu.be',
	'https://vid.puffyan.us',
	'https://yt.artemislena.eu',
	'https://invidious.flokinet.to',
	'https://invidious.projectsegfau.lt',
	'https://invidious.privacydev.net',
	'https://iv.melmac.space',
	'https://iv.ggtyler.dev',
	'https://invidious.lunar.icu',
	'https://inv.nadeko.net',
	'https://inv.tux.pizza',
	'https://invidious.protokolla.fi',
	'https://iv.nboeck.de',
	'https://invidious.private.coffee',
	'https://yt.drgnz.club',
	'https://iv.datura.network',
	'https://invidious.fdn.fr',
	'https://invidious.perennialte.ch',
	'https://yt.cdaut.de',
	'https://invidious.drgns.space',
	'https://inv.us.projectsegfau.lt',
	'https://invidious.einfachzocken.eu',
	'https://invidious.nerdvpn.de',
	'https://invidious.jing.rocks',
	'https://vid.lilay.dev',
	'https://invidious.privacyredirect.com',
	'https://invidious.reallyaweso.me',
	'https://invidious.materialio.us',
	'https://inv.in.projectsegfau.lt',
	'https://invidious.incogniweb.net',
]

pub enum InvidiousContainer {
	mp4
	webm
	m4a
}

pub fn (container InvidiousContainer) str() string {
	return match container {
		.mp4 { 'mp4' }
		.webm { 'webm' }
		.m4a { 'm4a' }
	}
}

pub enum InvidiousMedia {
	video
	audio
}

pub fn (media InvidiousMedia) str() string {
	return match media {
		.video { 'video' }
		.audio { 'audio' }
	}
}

pub enum InvidiousQualityAudio {
	audio_quality_low
	audio_quality_medium
}

pub fn (quality InvidiousQualityAudio) str() string {
	return match quality {
		.audio_quality_low { 'AUDIO_QUALITY_LOW' }
		.audio_quality_medium { 'AUDIO_QUALITY_MEDIUM' }
	}
}

pub enum InvidiousQualityVideo {
	q144p
	q240p
	q360p
	q480p
	q720p
	q1080p
}

pub fn (quality InvidiousQualityVideo) str() string {
	return match quality {
		.q144p { '144p' }
		.q240p { '240p' }
		.q360p { '360p' }
		.q480p { '480p' }
		.q720p { '720p' }
		.q1080p { '1080p' }
	}
}

type InvidiousQuality = InvidiousQualityAudio | InvidiousQualityVideo

pub struct InvidiousFilter {
pub:
	container InvidiousContainer @[required]
	quality   InvidiousQuality   @[required]
}

pub struct InvidiousRequest {
pub:
	invidious_instance_url string
	url     string            @[required]
	media   InvidiousMedia    @[required]
	filters []InvidiousFilter @[required]
}

struct InvidiousResponse {
	title            string
	length_seconds   int             @[json: lengthSeconds]
	adaptive_formats []struct {
		type_         string @[json: "type"]
		url           string
		encoding      string
		container     string
		quality_label string @[json: qualityLabel]
		audio_quality string @[json: audioQuality]
		resolution    string
	} @[json: adaptiveFormats]
}

pub fn invidious_get_download(request InvidiousRequest) !DownloadInfo {
	video_id := get_video_id(request.url)!
	instances := if request.invidious_instance_url != '' {
		[request.invidious_instance_url]
	} else {
		youtubedl.invidious_instances
	}
	for instance in instances {
		resp_resp := http.get('${instance}/api/v1/videos/${video_id}') or { continue }
		if resp_resp.status_code != 200 {
			continue
		}
		resp := json.decode(InvidiousResponse, resp_resp.body) or { continue }
		for filter in request.filters {
			for adaptive_fmt in resp.adaptive_formats {
				if !adaptive_fmt.type_.starts_with(request.media.str()) {
					continue
				}
				if adaptive_fmt.container != filter.container.str() {
					continue
				}
				is_ok := match filter.quality {
					InvidiousQualityAudio {
						filter.quality.str() == adaptive_fmt.audio_quality
					}
					InvidiousQualityVideo {
						filter.quality.str() == adaptive_fmt.quality_label
					}
				}
				if !is_ok {
					continue
				}
				return DownloadInfo{
					title: resp.title
					download_url: adaptive_fmt.url
					extension: adaptive_fmt.container
					length_seconds: resp.length_seconds
				}
			}
		}
		return error('Could not find with the filters you provided')
	}
	return error('Could not find with the filters you provided')
}
