package com.thered.stocksignal.service.news;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thered.stocksignal.app.dto.NewsDto.NewsResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NewsServiceImpl implements NewsService {

    private final ObjectMapper objectMapper;

    @Value("${naver.client.id}")
    private String clientId;

    @Value("${naver.client.secret}")
    private String clientSecret;

    public List<NewsResponseDto> searchNews(String query) {

        try {
            String encodedQuery = URLEncoder.encode(query+" 주식 속보", "UTF-8");

            String apiURL = String.format("https://openapi.naver.com/v1/search/news.json?query=%s&display=3&start=1&sort=date", encodedQuery);

            HttpURLConnection con = (HttpURLConnection) new URL(apiURL).openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("X-Naver-Client-Id", clientId);
            con.setRequestProperty("X-Naver-Client-Secret", clientSecret);

            int responseCode = con.getResponseCode();

            InputStream inputStream = (responseCode == HttpURLConnection.HTTP_OK) ? con.getInputStream() : con.getErrorStream();

            return parseResponse(inputStream);

        } catch (Exception e) {
            throw new RuntimeException("뉴스 검색을 위한 기본 정보를 확인해주세요");
        }
    }

    private List<NewsResponseDto> parseResponse(InputStream inputStream) {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {

            StringBuilder responseBody = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                responseBody.append(line);
            }

            JsonNode jsonNode = objectMapper.readTree(responseBody.toString());
            List<NewsResponseDto> newsList = new ArrayList<>();

            for (JsonNode item : jsonNode.path("items")) {
                NewsResponseDto news = NewsResponseDto.builder().build();

                news.setTitle(item.path("title").asText());
                news.setUrl(item.path("link").asText());
                news.setPubDate(item.path("pubDate").asText());

                newsList.add(news);
            }

            return newsList;

        } catch (Exception e) {
            throw new RuntimeException("뉴스 파싱중 예외가 발생하였습니다.");
        }
    }
}
