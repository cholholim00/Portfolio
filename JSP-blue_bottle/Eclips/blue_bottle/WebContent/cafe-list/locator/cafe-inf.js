// 개선된 코드 (문제 해결 버전)
var carouselWidth = $('.carousel-inner')[0].scrollWidth;
var cardWidth = $('.carousel-item').width();
var scrollPosition = 0;

$("#CarouselControl .carousel-control-next").on("click", function(e) {
    e.preventDefault();  // 추가: 기본 동작 차단
    
    // 추가: 클릭할 때마다 정확한 너비 재계산 (화면 크기 변경 대응)
    carouselWidth = $('.carousel-inner')[0].scrollWidth;
    cardWidth = $('.carousel-item').outerWidth(true);  // 변경: margin 포함한 정확한 너비
    
    var containerWidth = $('.carousel-inner').width();  // 추가: 컨테이너 너비
    var maxScroll = carouselWidth - containerWidth;     // 변경: 고정값 3 대신 실제 컨테이너 너비 사용
    
    if (scrollPosition < maxScroll) {
        scrollPosition += cardWidth;
        
        // 추가: 경계값 넘지 않도록 보정
        if (scrollPosition > maxScroll) {
            scrollPosition = maxScroll;
        }
        
        $("#CarouselControl .carousel-inner").animate(
            { scrollLeft: scrollPosition },
            200
        );
    }
});

$("#CarouselControl .carousel-control-prev").on("click", function(e) {
    e.preventDefault();  // 추가: 기본 동작 차단
    
    // 추가: 클릭할 때마다 정확한 너비 재계산
    carouselWidth = $('.carousel-inner')[0].scrollWidth;
    cardWidth = $('.carousel-item').outerWidth(true);  // 변경: margin 포함한 정확한 너비
    
    if (scrollPosition > 0) {
        scrollPosition -= cardWidth;
        
        // 추가: 경계값 넘지 않도록 보정
        if (scrollPosition < 0) {
            scrollPosition = 0;
        }
        
        $("#CarouselControl .carousel-inner").animate(
            { scrollLeft: scrollPosition },
            200
        );
    }
})