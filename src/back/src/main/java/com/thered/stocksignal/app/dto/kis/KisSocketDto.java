package com.thered.stocksignal.app.dto.kis;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

public class KisSocketDto {

    @Getter
    @Setter
    @Builder
    public static class Header {
        private String approval_key;
        private String custtype;
        private String tr_type;
        private String content_type;
    }

    @Getter
    @Setter
    @Builder
    public static class Input {
        private String tr_id;
        private String tr_key;
    }

    @Getter
    @Setter
    @Builder
    public static class Body {
        private Input input;
    }

    @Getter
    @Setter
    @Builder
    public static class KisSocketRequestDto {
        private Header header;
        private Body body;
    }

}
