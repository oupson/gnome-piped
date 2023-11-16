namespace Piped.PipedApi {
    class PipedStream : Object {
        public string url { get; set; }
        public string format { get; set; }
        public string quality { get; set; }
        public string mimeType { get; set; }
        public string codec { get; set; }
        public string audioTrackId { get; set; }
        public string audioTrackName { get; set; }
        public string audioTrackType { get; set; }
        public string audioTrackLocale { get; set; }

        public bool videoOnly { get; set; }

        public int itag { get; set; }
        public int bitrate { get; set; }
        public int initStart { get; set; }
        public int initEnd { get; set; }
        public int indexStart { get; set; }
        public int indexEnd { get; set; }
        public int width { get; set; }
        public int height { get; set; }
        public int fps { get; set; }

        public long contentLength { get; set; }
    }
}
