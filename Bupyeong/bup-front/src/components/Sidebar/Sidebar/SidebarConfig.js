
const sidebarConfig = [
  // =====================================================
  // 정기권
  // =====================================================
  {
    //리스트처럼 묶었다고 생각하면됌
    title: "정기권 신청",

    routeNames: [
      "pass",
      "passapply",
      "passinfo",
      "passnow"
    ],

    menus: [
        /*activeNames : 어떤 페이지들을 같은 메뉴로 선택 표시할지 */
      {
        label: "정기권 발매 현황",
        name: "passnow",
        activeNames: ["passnow"]
      },
      {
        label: "정기권 신청",
        name: "pass",

        // 정기권 안내 화면과 실제 신청 화면을 같은 메뉴로 처리
        activeNames: ["pass", "passapply"]
      },
      {
        label: "정기권 이용안내",
        name: "passinfo",
        activeNames: ["passinfo"]
      }
    ]
  },

  // =====================================================
  // 주차
  // =====================================================
  {
    title: "주차",

    routeNames: [
      "park",
      "parkinfo",
      "parkcost"
    ],

    menus: [
      {
        label: "주차 현황",
        name: "park",
        activeNames: ["park"]
      },
      {
        label: "주차장 소개",
        name: "parkinfo",
        activeNames: ["parkinfo"]
      },
      {
        label: "주차 요금 안내",
        name: "parkcost",
        activeNames: ["parkcost"]
      }
    ]
  },

  // =====================================================
  // 상가
  // =====================================================
  {
    title: "상가",

    routeNames: [
      "stores"
    ],

    menus: [
      {
        label: "상가 정보",
        name: "stores",
        activeNames: ["stores"]
      }
    ]
  },

  // =====================================================
  // 공지 / 문의
  // =====================================================
  {
    title: "공지 / 문의",

    /*
    active
     */
    routeNames: [
      "notice",
      "noticedetail",
      "noticewrite",
      "noticeupdate",

      "faq",
      "faqdetail",
      "faqwrite",
      "faqupdate",

      "qna",
      "qnawrite",
      "qnadetail",
      "qnaupdate"
    ],

    menus: [
      {
        label: "공지사항",
        name: "notice",
        activeNames: [
          "notice",
          "noticedetail",
          "noticewrite",
          "noticeupdate"
        ]
      },
      {
        label: "1:1 질의응답",
        name: "qna",
        activeNames: [
          "qna",
          "qnawrite",
          "qnadetail",
          "qnaupdate"
        ]
      },
      {
        label: "자주 묻는 질문",
        name: "faq",
        activeNames: [
          "faq",
          "faqdetail",
          "faqwrite",
          "faqupdate"
        ]
      }
    ]
  },

  // =====================================================
  // 자유게시판
  // =====================================================
  {
    title: "자유게시판",

    routeNames: [
      "boardlist",
      "boardwrite",
      "boarddetail"
    ],

    menus: [
      {
        label: "3조의 수다방",
        name: "boardlist",
        activeNames: [
          "boardlist",
          "boardwrite",
          "boarddetail"
        ]
      }
    ]
  },

  // =====================================================
  // 마이페이지
  // =====================================================
  {
    title: "마이페이지",

    routeNames: [
      "my",
      "myupdate",
      "mycar",
      "mypass",
      "myfaqlist"
    ],

    menus: [
      {
        label: "내 정보",
        name: "my",

        // 내 정보 수정 화면에서도 "내 정보"를 선택된 메뉴로 표시
        activeNames: ["my", "myupdate"]
      },
      {
        label: "내 주차 현황/정산",
        name: "mycar",
        activeNames: ["mycar"]
      },
      {
        label: "마이 정기권",
        name: "mypass",
        activeNames: ["mypass"]
      },
      {
        label: "나의 질의응답 조회",
        name: "myfaqlist",
        activeNames: ["myfaqlist"]
      }
    ]
  },

];

export default sidebarConfig;