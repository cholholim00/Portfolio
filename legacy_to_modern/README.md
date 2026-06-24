# 🛠️ Legacy-to-Modern: 시스템 운영 현황 분석 및 아키텍처 점진적 개선

## 1. 프로젝트 개요
본 프로젝트는 기존 레거시(Legacy) 시스템의 소스코드를 분석하여 구조적 결함을 파악하고, 전체 시스템을 갈아엎지 않는 선에서 안정성과 보안성을 점진적으로 고도화(Refactoring)하는 것을 목표로 수행되었습니다.

## 2. 기존 시스템 문제점 분석 (AS-IS)
* **계층 구조 미비:** Service 계층 없이 Controller에서 DB(`JdbcTemplate`)를 직접 제어.
* **보안 취약점:** 사용자 입력값이 SQL 쿼리에 단순 문자열 결합 형태로 노출 (SQL Injection 위험).
* **운영 안정성 결여:** 글로벌 예외 처리 부재로 에러 시 톰캣 500 에러 노출 및 표준 로거 미사용.
* **데이터 무결성 훼손:** 클라이언트 입력값에 대한 서버 단의 검증(Validation) 로직 부재로 인한 DB 에러 유발 위험.

## 3. 주요 유지보수 및 개선 조치 (TO-BE)
| 개선 항목 | 조치 내용 | 기대 효과 |
|---|---|---|
| **SQL 인젝션 방어** | 상세 조회 API 쿼리를 `PreparedStatement` 바인딩 방식으로 전면 교체 | 데이터베이스 탈취 우회 공격 원천 차단 |
| **데이터 무결성 검증** | DTO 분리 및 `Spring Validation(@Valid)` 도입, 400 에러 예외 처리 | 불량 데이터 유입 사전 차단 및 서버 자원 낭비 방지 |
| **전역 예외 처리 도입** | `@ControllerAdvice`를 활용한 `GlobalExceptionHandler` 클래스 분리 | 내부 에러 스택 은닉 및 보안 강화 (404/500 응답 규격화) |
| **운영 로깅 시스템** | `System.out.print` 제거 및 `@Slf4j` 도입 | 운영 환경에서의 에러 추적 및 트러블슈팅 기반 마련 |
| **DB 자동화** | `schema.sql`, `data.sql` 및 초기화 옵션 설정 | 배포 시 독립적인 DB 환경 자동 구성 |

## 4. 기술 스택
* **Backend:** Java 17, Spring Boot 3.5, Spring Web, Spring Validation
* **Database:** MySQL 8.0 (Docker), Spring JDBC
* **Tool:** IntelliJ IDEA Community, Git