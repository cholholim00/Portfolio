package review.board;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.JDBConnect;

public class BoardDAO extends JDBConnect {
	
	// 페이지네이션 상수들을 Java에서 관리
	public static final int DEFAULT_PAGE_SIZE = 6; // 기본 페이지 크기
	public static final int BLOCK_SIZE = 5; // 페이지 블록 크기
	public static final int MAX_PAGE_SIZE = 20; // 최대 페이지 크기 (보안용)
		
	public BoardDAO() {}
	

	// 검색 조건에 맞는 게시물의 개수를 반환합니다.
	public int selectCount(Map<String, Object> map) {
		int count = 0;
		String query = "SELECT COUNT(*) FROM review r LEFT JOIN product p ON r.product_idx = p.product_idx";
		
		if (map.get("searchField") != null && !map.get("searchField").toString().isEmpty()) {
			String searchField = map.get("searchField").toString();
			if ("product_name".equals(searchField) && map.get("searchWord") != null && !map.get("searchWord").toString().isEmpty()) {
				query += " WHERE p.name LIKE ?";
			} else if ("category".equals(searchField)) {
				if (map.get("categoryIdx") != null) {
					query += " WHERE p.category_idx = ?";
					if (map.get("searchWord") != null && !map.get("searchWord").toString().isEmpty()) {
						query += " AND p.name LIKE ?";
					}
				}
			}
		}
		
		try {
			pstmt = getConnection().prepareStatement(query);
			int paramIndex = 1;
			
			if (map.get("searchField") != null && !map.get("searchField").toString().isEmpty()) {
				String searchField = map.get("searchField").toString();
				if ("product_name".equals(searchField) && map.get("searchWord") != null && !map.get("searchWord").toString().isEmpty()) {
					pstmt.setString(paramIndex++, "%" + map.get("searchWord").toString() + "%");
				} else if ("category".equals(searchField) && map.get("categoryIdx") != null) {
					pstmt.setInt(paramIndex++, (Integer) map.get("categoryIdx"));
					if (map.get("searchWord") != null && !map.get("searchWord").toString().isEmpty()) {
						pstmt.setString(paramIndex++, "%" + map.get("searchWord").toString() + "%");
					}
				}
			}
			
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch(Exception e) {
			System.out.println("Exception[selectCount]: " + e.getMessage());
		}
		return count;
	}

	// 검색 조건에 맞는 게시물 목록을 페이지별로 반환합니다. 페이지 크기는 고정으로 사용
	public List<BoardDTO> selectList(Map<String, Object> map) {
		int pageSize = DEFAULT_PAGE_SIZE;
		
		List<BoardDTO> bbs = new ArrayList<BoardDTO>();
		
		int pageNo = (Integer) map.getOrDefault("pageNo", 1);
		int offset = (pageNo - 1) * pageSize;
		int startRow = offset + 1;
		int endRow = offset + pageSize;
		
		String query = "SELECT * FROM (" +
		               "    SELECT b.*, ROWNUM rnum FROM (" +
		               "        SELECT r.*, u.user_id as username, p.name as product_name FROM review r " +
		               "        LEFT JOIN users u ON r.user_idx = u.idx " +
		               "        LEFT JOIN product p ON r.product_idx = p.product_idx";
		
		// 검색 조건 처리
		if (map.get("searchField") != null && !map.get("searchField").toString().isEmpty()) {
			String searchField = map.get("searchField").toString();
			if ("product_name".equals(searchField) && map.get("searchWord") != null && !map.get("searchWord").toString().isEmpty()) {
				query += " WHERE p.name LIKE ?";
			} else if ("category".equals(searchField)) {
				if (map.get("categoryIdx") != null) {
					query += " WHERE p.category_idx = ?";
					if (map.get("searchWord") != null && !map.get("searchWord").toString().isEmpty()) {
						query += " AND p.name LIKE ?";
					}
				}
			}
		}
		
		query += "        ORDER BY r.post_date DESC" +
		         "    ) b WHERE ROWNUM <= ?" +
		         ") WHERE rnum >= ?";
		
		try {
			pstmt = getConnection().prepareStatement(query);
			
			int paramIndex = 1;
			
			// 검색 조건 파라미터 설정
			if (map.get("searchField") != null && !map.get("searchField").toString().isEmpty()) {
				String searchField = map.get("searchField").toString();
				if ("product_name".equals(searchField) && map.get("searchWord") != null && !map.get("searchWord").toString().isEmpty()) {
					pstmt.setString(paramIndex++, "%" + map.get("searchWord").toString() + "%");
				} else if ("category".equals(searchField) && map.get("categoryIdx") != null) {
					pstmt.setInt(paramIndex++, (Integer) map.get("categoryIdx"));
					if (map.get("searchWord") != null && !map.get("searchWord").toString().isEmpty()) {
						pstmt.setString(paramIndex++, "%" + map.get("searchWord").toString() + "%");
					}
				}
			}
			
			// Oracle ROWNUM 파라미터 설정
			pstmt.setInt(paramIndex++, endRow);
			pstmt.setInt(paramIndex, startRow);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setReview_idx(rs.getInt("review_idx"));
				board.setRating(rs.getInt("rating"));
				board.setTitle(rs.getString("title"));
				board.setContent(rs.getString("content")); 
				board.setPost_date(rs.getDate("post_date"));
				board.setVisit_count(rs.getInt("visit_count"));
				board.setUser_idx(rs.getInt("user_idx"));
				board.setProduct_idx(rs.getString("product_idx"));
				board.setUsername(rs.getString("username"));
				board.setProductName(rs.getString("product_name"));
				bbs.add(board);
			}
			
		} catch(Exception e) {
			System.out.println("Exception[selectList]:" + e.getMessage());
		}
		return bbs;
	}
	
	// 특정 상품의 최근 리뷰 목록 (최신순 limit)
	public List<BoardDTO> getRecentReviews(String productId, int limit) {
	    List<BoardDTO> list = new ArrayList<>();
	    String query = "SELECT r.*, u.user_id as username FROM review r " +
	                   "LEFT JOIN users u ON r.user_idx = u.idx " +
	                   "WHERE r.product_idx = ? ORDER BY r.post_date DESC";
	    
	    // Oracle에서는 FETCH FIRST 대신 ROWNUM 사용
	    if (limit > 0) {
	        query = "SELECT * FROM (" + query + ") WHERE ROWNUM <= ?";
	    }
	    
	    try {
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setString(1, productId);
	        if (limit > 0) {
	            pstmt.setInt(2, limit);
	        }
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            BoardDTO dto = new BoardDTO();
	            dto.setReview_idx(rs.getInt("review_idx"));
	            dto.setRating(rs.getInt("rating"));
	            dto.setTitle(rs.getString("title"));
	            dto.setContent(rs.getString("content"));
	            dto.setPost_date(rs.getDate("post_date"));
	            dto.setVisit_count(rs.getInt("visit_count"));
	            dto.setUser_idx(rs.getInt("user_idx"));
	            dto.setProduct_idx(rs.getString("product_idx"));
	            dto.setUsername(rs.getString("username"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        System.out.println("Exception[getRecentReviews]: " + e.getMessage());
	    }
	    return list;
	}
	
	// 페이지네이션 정보를 계산해서 반환하는 유틸리티 메서드
	public Map<String, Object> calculatePagination(int totalCount, int pageNo) {
		Map<String, Object> pagination = new HashMap<>();
		
		int pageSize = DEFAULT_PAGE_SIZE;
		if (pageNo <= 0) {
			pageNo = 1;
		}
		
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);
		if (totalPages == 0) totalPages = 1;
		
		// 페이지 번호가 총 페이지 수를 초과하면 마지막 페이지로
		if (pageNo > totalPages) {
			pageNo = totalPages;
		}
		
		// 페이지 블록 계산
		int startPage = ((pageNo - 1) / BLOCK_SIZE) * BLOCK_SIZE + 1;
		int endPage = Math.min(startPage + BLOCK_SIZE - 1, totalPages);
		
		pagination.put("pageNo", pageNo);
		pagination.put("pageSize", pageSize);
		pagination.put("totalCount", totalCount);
		pagination.put("totalPages", totalPages);
		pagination.put("startPage", startPage);
		pagination.put("endPage", endPage);
		pagination.put("blockSize", BLOCK_SIZE);
		
		return pagination;
	}
	
	// 특정 상품의 평균 별점 조회
	public double getAverageRating(String productId) {
	    double avgRating = 0.0;
	    String query = "SELECT AVG(rating) as avg_rating FROM review WHERE product_idx = ?";
	    try {
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setString(1, productId);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            avgRating = rs.getDouble("avg_rating");
	        }
	    } catch (Exception e) {
	        System.out.println("Exception[getAverageRating]: " + e.getMessage());
	    }
	    return Math.round(avgRating * 10.0) / 10.0; // 소수점 첫째자리까지
	}
	
	// 특정 상품의 리뷰 개수 조회
	public int getReviewCount(String productId) {
	    int count = 0;
	    String query = "SELECT COUNT(*) FROM review WHERE product_idx = ?";
	    try {
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setString(1, productId);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	    } catch (Exception e) {
	        System.out.println("Exception[getReviewCount]: " + e.getMessage());
	    }
	    return count;
	}
	
	// 별점별 리뷰 개수 통계
	public Map<Integer, Integer> getRatingStatistics(String productId) {
	    Map<Integer, Integer> stats = new HashMap<>();
	    // 1~5점 초기화
	    for (int i = 1; i <= 5; i++) {
	        stats.put(i, 0);
	    }
	    
	    String query = "SELECT rating, COUNT(*) as count FROM review WHERE product_idx = ? GROUP BY rating";
	    try {
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setString(1, productId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            stats.put(rs.getInt("rating"), rs.getInt("count"));
	        }
	    } catch (Exception e) {
	        System.out.println("Exception[getRatingStatistics]: " + e.getMessage());
	    }
	    return stats;
	}

	// 이미지 없이 리뷰만 저장 (간단한 리뷰용)
	public int insertWriteSimple(BoardDTO dto) {
	    int count = 0;
	    String query = "INSERT INTO review (rating, title, content, post_date, visit_count, user_idx, product_idx) " +
	                   "VALUES (?, ?, ?, SYSDATE, 0, ?, ?)";
	    try {
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setInt(1, dto.getRating());
	        pstmt.setString(2, dto.getTitle());
	        pstmt.setString(3, dto.getContent());
	        pstmt.setInt(4, dto.getUser_idx());
	        pstmt.setString(5, dto.getProduct_idx());
	        count = pstmt.executeUpdate();
	    } catch(Exception e) {
	        System.out.println("Exception[insertWriteSimple]: " + e.getMessage());
	        e.printStackTrace();
	    }
	    return count;
	}

	// 이미지와 함께 리뷰 저장 (review_idx 반환)
	public int insertWriteWithImage(BoardDTO dto) {
	    int reviewIdx = 0;
	    
	    try {
	        // 1. 시퀀스 다음 값 가져오기
	        String seqQuery = "SELECT seq_review_idx.NEXTVAL FROM dual";
	        pstmt = getConnection().prepareStatement(seqQuery);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            reviewIdx = rs.getInt(1);
	        }
	        rs.close();
	        pstmt.close();
	        
	        // 2. 가져온 시퀀스 값으로 리뷰 INSERT
	        String insertQuery = "INSERT INTO review (review_idx, rating, title, content, post_date, visit_count, user_idx, product_idx) " +
	                             "VALUES (?, ?, ?, ?, SYSDATE, 0, ?, ?)";
	        pstmt = getConnection().prepareStatement(insertQuery);
	        pstmt.setInt(1, reviewIdx);
	        pstmt.setInt(2, dto.getRating());
	        pstmt.setString(3, dto.getTitle());
	        pstmt.setString(4, dto.getContent());
	        pstmt.setInt(5, dto.getUser_idx());
	        pstmt.setString(6, dto.getProduct_idx());
	        
	        int result = pstmt.executeUpdate();
	        
	        // 성공하면 생성된 review_idx 반환, 실패하면 -1 반환
	        return (result > 0) ? reviewIdx : -1;
	        
	    } catch(Exception e) {
	        System.out.println("Exception[insertWriteWithImage]:" + e.getMessage());
	        e.printStackTrace();
	        return -1;
	    }
	}

	// 지정한 리뷰를 수정합니다.
	public int updateEdit(BoardDTO dto) { 
	    int rowCount = 0;
	    try {
	        String query = "UPDATE review SET rating=?, title=?, content=? WHERE review_idx=?";
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setInt(1, dto.getRating());
	        pstmt.setString(2, dto.getTitle());
	        pstmt.setString(3, dto.getContent());
	        pstmt.setInt(4, dto.getReview_idx());
	        rowCount = pstmt.executeUpdate();
	    } catch(Exception e) {
	        System.out.println("Exception[updateEdit]: " + e.getMessage());
	    }
	    return rowCount;  
	}

	// 지정한 리뷰를 삭제합니다.
	public int deletePost(BoardDTO dto) { 
	    int rowCount = 0;
	    try {
	        String query = "DELETE FROM review WHERE review_idx=?";
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setInt(1, dto.getReview_idx());
	        rowCount = pstmt.executeUpdate();
	    } catch(Exception e) {
	        System.out.println("Exception[deletePost]: " + e.getMessage());
	    }
	    return rowCount; 
	}
	
	// 조회수 증가
	public void updateVisitCount(String reviewIdx) {
	    String query = "UPDATE review SET visit_count = visit_count + 1 WHERE review_idx = ?";
	    
	    try {
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setString(1, reviewIdx);
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        System.out.println("Exception[updateVisitCount]: " + e.getMessage());
	        e.printStackTrace();
	    }
	}
	
	// 리뷰 상세보기
	public BoardDTO selectView(String reviewIdx) {
	    BoardDTO dto = null;
	    String query = "SELECT r.*, u.user_id as username, p.name as product_name " +
	                   "FROM review r " +
	                   "LEFT JOIN users u ON r.user_idx = u.idx " +
	                   "LEFT JOIN product p ON r.product_idx = p.product_idx " +
	                   "WHERE r.review_idx = ?";
	    try {
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setInt(1, Integer.parseInt(reviewIdx));
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            dto = new BoardDTO();
	            dto.setReview_idx(rs.getInt("review_idx"));
	            dto.setRating(rs.getInt("rating"));
	            dto.setTitle(rs.getString("title"));
	            dto.setContent(rs.getString("content"));
	            dto.setPost_date(rs.getDate("post_date"));
	            dto.setVisit_count(rs.getInt("visit_count"));
	            dto.setUser_idx(rs.getInt("user_idx"));
	            dto.setProduct_idx(rs.getString("product_idx"));
	            dto.setUsername(rs.getString("username"));
	            dto.setProductName(rs.getString("product_name"));
	        }
	    } catch(Exception e) {
	        System.out.println("Exception[selectView]: " + e.getMessage());
	    }
	    return dto;
	}
	
	// ===== 이미지 관련 메서드 =====
	
	// 간단 조회(view.jsp)
	public String getReviewImageUrl(int reviewIdx) {
	    String imageUrl = null;
	    String query = "SELECT image_url FROM review_image WHERE review_idx = ? AND ROWNUM = 1";
	    
	    try {
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setInt(1, reviewIdx);
	        rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            imageUrl = rs.getString("image_url");
	        }
	    } catch (Exception e) {
	        System.out.println("Exception[getReviewImageUrl]: " + e.getMessage());
	        e.printStackTrace();
	    }
	    
	    return imageUrl;
	}
	
	// 여러 리뷰의 이미지 정보를 한 번에 가져오는 메서드 
	public Map<Integer, String> getReviewImagesMap(List<Integer> reviewIdxList) {
	    Map<Integer, String> imageMap = new HashMap<>();
	    
	    if (reviewIdxList == null || reviewIdxList.isEmpty()) {
	        return imageMap;
	    }
	    
	    // IN 절을 위한 쿼리 생성
	    StringBuilder queryBuilder = new StringBuilder();
	    queryBuilder.append("SELECT review_idx, image_url FROM review_image WHERE review_idx IN (");
	    
	    for (int i = 0; i < reviewIdxList.size(); i++) {
	        if (i > 0) queryBuilder.append(",");
	        queryBuilder.append("?");
	    }
	    queryBuilder.append(")");
	    
	    try {
	        pstmt = getConnection().prepareStatement(queryBuilder.toString());
	        
	        // 파라미터 설정
	        for (int i = 0; i < reviewIdxList.size(); i++) {
	            pstmt.setInt(i + 1, reviewIdxList.get(i));
	        }
	        
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            int reviewIdx = rs.getInt("review_idx");
	            String imageUrl = rs.getString("image_url");
	            imageMap.put(reviewIdx, imageUrl);
	        }
	        
	    } catch (Exception e) {
	        System.out.println("Exception[getReviewImagesMap]: " + e.getMessage());
	    }
	    
	    return imageMap;
	}
	
	// BoardDAO.java에 추가할 메소드

	// 특정 사용자가 작성한 리뷰 목록 조회
	public List<BoardDTO> getUserReviews(int userIdx, int limit, int offset) {
	    List<BoardDTO> list = new ArrayList<>();
	    String query = "SELECT r.*, u.user_id as username FROM review r " +
	                   "LEFT JOIN users u ON r.user_idx = u.idx " +
	                   "WHERE r.user_idx = ? ORDER BY r.post_date DESC";
	    
	    // Oracle에서는 LIMIT 대신 ROWNUM 사용
	    if (limit > 0) {
	        query = "SELECT * FROM (" + query + ") WHERE ROWNUM <= ?";
	    }
	    
	    try {
	        pstmt = getConnection().prepareStatement(query);
	        pstmt.setInt(1, userIdx);
	        if (limit > 0) {
	            pstmt.setInt(2, limit);
	        }
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            BoardDTO dto = new BoardDTO();
	            dto.setReview_idx(rs.getInt("review_idx"));
	            dto.setRating(rs.getInt("rating"));
	            dto.setTitle(rs.getString("title"));
	            dto.setContent(rs.getString("content"));
	            dto.setPost_date(rs.getDate("post_date"));
	            dto.setVisit_count(rs.getInt("visit_count"));
	            dto.setUser_idx(rs.getInt("user_idx"));
	            dto.setProduct_idx(rs.getString("product_idx"));
	            dto.setUsername(rs.getString("username"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        System.out.println("Exception[getUserReviews]: " + e.getMessage());
	    }
	    return list;
	}
	
	public static String getProductImageUrl(String productId) {
	    // 상품별 개별 이미지 매핑
	    switch(productId) {
	        case "1-001": return "./images/product/1-001.webp";
	        case "1-002": return "./images/product/1-002.webp";
	        case "1-007": return "./images/product/1-007.webp";
	        case "1-008": return "./images/product/1-008.webp";
	        case "1-009": return "./images/product/1-009.webp";
	        case "1-010": return "./images/product/1-010.webp";
	        case "1-011": return "./images/product/1-011.webp";
	        case "1-017": return "./images/product/1-017.webp";
	        case "1-018": return "./images/product/1-018.webp";
	        
	        case "2-001": return "./images/product/2-001.webp";
	        case "2-002": return "./images/product/2-002.webp";
	        case "2-003": return "./images/product/2-003.webp";
	        case "2-021": return "./images/product/2-021.webp";
	        case "2-022": return "./images/product/2-022.webp";
	        case "2-023": return "./images/product/2-023.webp";
	        case "2-031": return "./images/product/2-031.webp";
	        case "2-032": return "./images/product/2-032.webp";
	        case "2-033": return "./images/product/2-033.webp";
	  
	        case "3-001": return "./images/product/3-001.webp";
	        case "3-002": return "./images/product/3-002.webp";
	        case "3-003": return "./images/product/3-003.webp";
	        case "3-004": return "./images/product/3-004.webp";
	        case "3-005": return "./images/product/3-005.webp";
	        case "3-006": return "./images/product/3-006.webp";
	        case "3-007": return "./images/product/3-007.webp";
	        case "3-008": return "./images/product/3-008.webp";
	        case "3-010": return "./images/product/3-010.webp";
	        
	        case "4-001": return "./images/product/4-001.webp";
	        case "4-003": return "./images/product/4-003.webp";
	        case "4-004": return "./images/product/4-004.webp";
	        case "4-005": return "./images/product/4-005.webp";
	        case "4-006": return "./images/product/4-006.webp";
	        case "4-007": return "./images/product/4-007.webp";
	        case "4-008": return "./images/product/4-008.webp";
	        case "4-010": return "./images/product/4-010.webp";
	        case "4-011": return "./images/product/4-011.webp";
	        
	        case "5-001": return "./images/product/5-001.webp";
	        
	        default: return "./images/review/sample.jpg";
	    }
	}
}