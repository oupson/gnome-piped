namespace Piped.PipedApi {
    class Streams : Object {
        public string title  { get; set; }
        public string description { get; set; }
        public string uploadDate { get; set; }
        public string uploader { get; set; }
        public string uploaderUrl { get; set; }
        public string uploaderAvatar { get; set; }
        public string thumbnailUrl { get; set; }
        public string hls { get; set; }
        public string dash { get; set; }
        public string lbryId { get; set; }
        public string category { get; set; }
        public string license { get; set; }
        public string visibility { get; set; }
        public string[] tags { get; set; }
        public MetaInfo[] metaInfo { get; set; }
        public bool uploaderVerified { get; set; }
        public long duration { get; set; }
        public long views { get; set; }
        public long likes { get; set; }
        public long dislikes { get; set; }
        public long uploaderSubscriberCount { get; set; }

        public PipedStream[] audioStreams { get; set; }
        public PipedStream[] videoStreams { get; set; }

        public ContentItem[] relatedStreams { get; set; }

        public Subtitle[] subtitles { get; set; }

        public bool livestream { get; set; }

        public string proxyUrl { get; set; }

        //public List<ChapterSegment> chapters;
        // public List<PreviewFrames> previewFrames;
    }
}
