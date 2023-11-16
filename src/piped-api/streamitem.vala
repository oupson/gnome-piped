namespace Piped.PipedApi {
    public class StreamItem : Object {
        public string title { get; set; }
        public string thumbnail { get; set; }
        public string uploaderName { get; set; }
        public string uploaderUrl { get; set; }
        public string uploaderAvatar { get; set; }
        public string uploaderDate { get; set; }
        public string shortDescription { get; set; }

        public long duration { get; set; }
        public long views { get; set; }
        public long uploaded { get; set; }

        public bool uploaderVerified { get; set; }
        public bool isShort { get; set; }
    }
}
