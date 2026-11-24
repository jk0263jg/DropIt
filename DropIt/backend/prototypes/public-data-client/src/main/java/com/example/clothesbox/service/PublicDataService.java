package com.example.clothesbox.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.util.*;

@Service
public class PublicDataService {

    @Value("${public.data.api.key}")
    private String serviceKey;

    public List<Map<String, String>> getClothesBoxInfo() {
        try {
            // 🔐 반드시 인코딩된 키 사용 (application.properties에서 세팅)
            String url = "https://api.odcloud.kr/api/15068863/v1/uddi:2682c872-adbe-4623-9e29-a53467734a88"
                    + "?page=1&perPage=1000"
                    + "&serviceKey=" + serviceKey;

            URI uri = new URI(url);
            System.out.println(" 요청 URI: " + uri.toString());

            RestTemplate restTemplate = new RestTemplate();
            String response = restTemplate.getForObject(uri, String.class);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response);
            JsonNode dataArray = root.path("data");

            List<Map<String, String>> result = new ArrayList<>();
            for (JsonNode item : dataArray) {
                Map<String, String> marker = new HashMap<>();
                marker.put("latitude", item.path("위도").asText());
                marker.put("longitude", item.path("경도").asText());
                marker.put("address", item.path("설치장소(도로명)").asText());
                marker.put("dong", item.path("행정동").asText());
                result.add(marker);
            }

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
