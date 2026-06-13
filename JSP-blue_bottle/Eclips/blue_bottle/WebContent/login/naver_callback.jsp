<%@ page import="java.io.*, java.net.*, org.json.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
try {
    String clientId = "idsucaZvW7szN_1HKKlX";
    String clientSecret = "YNxGGWPuOM";
    String code = request.getParameter("code");
    String state = request.getParameter("state");
    String error = request.getParameter("error");
    String errorDescription = request.getParameter("error_description");
    
    // 에러 체크
    if (error != null) {
        out.println("네이버 로그인 에러: " + error + " - " + errorDescription);
        return;
    }
    
    // 필수 파라미터 체크
    if (code == null || state == null) {
        out.println("필수 파라미터가 누락되었습니다.");
        return;
    }
    
    String sessionState = (String) session.getAttribute("naver_state");
    
    // CSRF 체크
    if (sessionState == null || !state.equals(sessionState)) {
        out.println("CSRF 공격이 감지되었습니다. 다시 로그인해주세요.");
        return;
    }
    
    // 1. 액세스 토큰 요청
    String redirectURI = URLEncoder.encode("http://localhost:8090/blue_bottle/login/naver_callback.jsp", "UTF-8");
    String tokenURL = "https://nid.naver.com/oauth2.0/token";
    
    // POST 방식으로 변경
    URL url = new URL(tokenURL);
    HttpURLConnection con = (HttpURLConnection)url.openConnection();
    con.setRequestMethod("POST");
    con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
    con.setDoOutput(true);
    
    String postData = "grant_type=authorization_code"
                    + "&client_id=" + clientId
                    + "&client_secret=" + clientSecret
                    + "&redirect_uri=" + redirectURI
                    + "&code=" + code
                    + "&state=" + state;
    
    OutputStreamWriter writer = new OutputStreamWriter(con.getOutputStream());
    writer.write(postData);
    writer.flush();
    writer.close();
    
    // 응답 코드 확인
    int responseCode = con.getResponseCode();
    if (responseCode != 200) {
        out.println("토큰 요청 실패. 응답 코드: " + responseCode);
        return;
    }
    
    BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
    String line, tokenResult = "";
    while ((line = br.readLine()) != null) {
        tokenResult += line;
    }
    br.close();
    
    JSONObject tokenObj = new JSONObject(tokenResult);
    
    // 토큰 응답 에러 체크
    if (tokenObj.has("error")) {
        out.println("토큰 발급 에러: " + tokenObj.getString("error"));
        return;
    }
    
    String accessToken = tokenObj.getString("access_token");
    
    // 2. 사용자 정보 요청
    URL userUrl = new URL("https://openapi.naver.com/v1/nid/me");
    HttpURLConnection userCon = (HttpURLConnection) userUrl.openConnection();
    userCon.setRequestMethod("GET");
    userCon.setRequestProperty("Authorization", "Bearer " + accessToken);
    
    int userResponseCode = userCon.getResponseCode();
    if (userResponseCode != 200) {
        out.println("사용자 정보 요청 실패. 응답 코드: " + userResponseCode);
        return;
    }
    
    BufferedReader userBr = new BufferedReader(new InputStreamReader(userCon.getInputStream()));
    String userLine, userResult = "";
    while ((userLine = userBr.readLine()) != null) {
        userResult += userLine;
    }
    userBr.close();
    
    JSONObject userJson = new JSONObject(userResult);
    
    // API 응답 에러 체크
    if (!userJson.getString("resultcode").equals("00")) {
        out.println("사용자 정보 조회 실패: " + userJson.getString("message"));
        return;
    }
    
    JSONObject responseJson = userJson.getJSONObject("response");
    
    String email = responseJson.optString("email", "");
    String name = responseJson.optString("name", "");
    String id = responseJson.optString("id", "");
    
    // 세션에 저장
    session.setAttribute("UserEmail", email);
    session.setAttribute("UserName", name);
    session.setAttribute("UserId", id);
    session.setAttribute("isLoggedIn", true);
    
    // 성공 후 리다이렉트
    response.sendRedirect("../main/index.jsp");
    
} catch (Exception e) {
    out.println("로그인 처리 중 오류가 발생했습니다: " + e.getMessage());
    e.printStackTrace();
}
%>