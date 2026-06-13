package review.image;

import common.JDBConnect;

public class ImageDAO extends JDBConnect {
	
	// 리뷰 이미지 등록
	public int insertReviewImage(ImageDTO dto) {
		int applyResult = 0;
		try {
			String query = "INSERT INTO review_image (review_img_idx, image_url, review_idx) " +
						   "VALUES (seq_review_img_idx.NEXTVAL, ?, ?)";
			pstmt = getConnection().prepareStatement(query);
			pstmt.setString(1, dto.getImage_url());
			pstmt.setInt(2, dto.getReview_idx());
			applyResult = pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("Exception[insertReviewImage]: " + e.getMessage());
			e.printStackTrace();
		}
		return applyResult;
	}
	
	// 리뷰 이미지 조회 (리뷰 ID로)
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
		}
		return imageUrl;
	}
	
	// 리뷰 이미지 삭제
	public int deleteReviewImage(int reviewIdx) {
		int result = 0;
		String query = "DELETE FROM review_image WHERE review_idx = ?";
		
		try {
			pstmt = getConnection().prepareStatement(query);
			pstmt.setInt(1, reviewIdx);
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("Exception[deleteReviewImage]: " + e.getMessage());
		}
		return result;
	}
}