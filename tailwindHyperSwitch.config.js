const plugin = require("tailwindcss/plugin");

module.exports = {
  darkMode: "class",
  content: ["./src/**/*.js"],
  theme: {
    fontFamily: {
      "inter-style": '"Inter"',
    },
    extend: {
      screens: {
        mobile: "28.125rem",
        tablet: "93.75rem",
        desktop: "118.75rem",
      },
      width: {
        58: "14.6875rem",
        94: "26.5rem",
        100: "25rem",
        120: "27rem",
        128: "31.25rem",
        133: "35rem",
        135: "35.625rem",
        "1.1-rem": "1.125rem",
        "45-vw": "45vw",
        "77-rem": "77rem",
        "80-rem": "80rem",
        "30-rem": "30rem",
        "35-rem": "35rem",
        "55-rem": "55rem",
        "22.7-rem": "22.75rem",
        pageWidth10: "62.5rem",
        pageWidth11: "75rem",
        pageWidth12: "85rem",
        pageWidth14: "101rem",
        successCardWidth: "52rem",
        fixedPageWidth: "75.5rem",
        standardPageWidth: "67.5rem",
      },
      scale: {
        400: "4",
      },
      rotate: {
        270: "270deg",
      },
      height: {
        "1.1-rem": "1.125rem",
        "5-rem": "5rem",
        "6-rem": "6rem",
        "7-rem": "7rem",
        "8-rem": "8rem",
        "12.5-rem": "12.5rem",
        "25-rem": "25rem",
        "30-rem": "30rem",
        "40-rem": "40rem",
        "45-rem": "45rem",
        "48-rem": "48rem",
        "50-rem": "50rem",
        "93-per": "93%",
        "80-vh": "80vh",
        "30-vh": "30vh",
        "40-vh": "40vh",
        "75-vh": "75vh",
        onBordingSupplier: "calc(100vh - 300px)",
      },
      maxHeight: {
        "25-rem": "25rem",
      },
      maxWidth: {
        fixedPageWidth: "82.75rem",
      },
      padding: {
        1: "4px",
        3.75: "15px",
        11.25: "45px",
      },
      animation: {
        "spin-slow": "spin 3s linear infinite",
        slideUp: "slideUp 200ms ease-out forwards",
        fade: "fadeOut 1s ease-in-out forwards",
        secondsOnes: "secondsOnes 10s 0s 18 reverse", // format keyframe, duration, delay, iteration-count, direction
        secondsTens: "secondsTens 60s 0s 3 forwards",
        minutesOnes: "minutesOnes 180s 0s 1 forwards",
        animateCards: "cardTransition 1s ease-in-out forwards",
        wobble: "wobble 0.2s ease-in-out",
        load: "load 3s normal forwards",
        growDown: "growDown .3s ease-out forwards",
        growUp: "growUp .2s ease-in forwards",
        textTransition: "textTransition .3s ease",
        textTransitionOff: "textTransitionOff .2s ease",
        dashCheck: "dashCheck .06s .08s ease-in-out backwards",
        ripple: "ripple 10s ease-in-out",
        horizontalShaking: "horizontalShaking 0.5s 1s",
        horizontalShakingDelay: "horizontalShaking 0.5s 4s",
      },
      transitionDelay: {
        12: "12000ms",
        24: "24000ms",
        36: "36000ms",
        48: "48000ms",
        60: "60000ms",
        84: "84000ms",
        96: "96000ms",
        18: "18000ms",
        36: "36000ms",
        54: "54000ms",
        72: "72000ms",
        90: "90000ms",
        108: "108000ms",
        126: "126000ms",
        144: "144000ms",
        162: "162000ms",
      },
      keyframes: (theme) => ({
        fadeOut: {
          "0%": { opacity: "100%" },
          "100%": { opacity: "0%" },
        },
        load: {
          "0%": { width: "0%" },
          "100%": { width: "90%" },
        },
        slideUp: {
          "0%": { opacity: "0%", transform: "translateY(5%)" },
          "100%": { opacity: "100%", transform: "translateY(0%)" },
        },
        secondsOnes: {
          "90%": {
            transform: "translateY(-216px)",
            animationTimingFunction: "cubic-bezier(1, 0, 1, 0)",
          },
          "80%": {
            transform: "translateY(-192px)",
            animationTimingFunction: "cubic-bezier(1, 0, 1, 0)",
          },
          "70%": {
            transform: "translateY(-168px)",
            animationTimingFunction: "cubic-bezier(1, 0, 1, 0)",
          },
          "60%": {
            transform: "translateY(-144px)",
            animationTimingFunction: "cubic-bezier(1, 0, 1, 0)",
          },
          "50%": {
            transform: "translateY(-120px)",
            animationTimingFunction: "cubic-bezier(1, 0, 1, 0)",
          },
          "40%": {
            transform: "translateY(-96px)",
            animationTimingFunction: "cubic-bezier(1, 0, 1, 0)",
          },
          "30%": {
            transform: "translateY(-72px)",
            animationTimingFunction: "cubic-bezier(1, 0, 1, 0)",
          },
          "20%": {
            transform: "translateY(-48px)",
            animationTimingFunction: "cubic-bezier(1, 0, 1, 0)",
          },
          "10%": {
            transform: "translateY(-24px)",
            animationTimingFunction: "cubic-bezier(1, 0, 1, 0)",
          },
          "0%": {
            transform: "translateY(-0px)",
            animationTimingFunction: "cubic-bezier(1, 0, 1, 0)",
          },
        },
        secondsTens: {
          "0%": {
            transform: "translateY(-24px)",
            animationTimingFunction: "steps(1, end)",
            animationDelay: "0s",
            animationDuration: "0s",
          },
          "16.6667%": {
            transform: "translateY(-48px)",
            animationTimingFunction: "steps(1, end)",
            animationDelay: "0s",
            animationDuration: "0s",
          },
          "33.3334%": {
            transform: "translateY(-72px)",
            animationTimingFunction: "steps(1, end)",
            animationDelay: "0s",
            animationDuration: "0s",
          },
          "50%": {
            transform: "translateY(-96px)",
            animationTimingFunction: "steps(1, end)",
            animationDelay: "0s",
            animationDuration: "0s",
          },
          "66.6667%": {
            transform: "translateY(-120px)",
            animationTimingFunction: "steps(1, end)",
            animationDelay: "0s",
            animationDuration: "0s",
          },
          "83.3334%": {
            transform: "translateY(-144px)",
            animationTimingFunction: "steps(1, end)",
            animationDelay: "0s",
            animationDuration: "0s",
          },
        },
        minutesOnes: {
          "0%": {
            transform: "translateY(-24px)",
            animationTimingFunction: "steps(1, end)",
          },
          "33.3334%": {
            transform: "translateY(-48px)",
            animationTimingFunction: "steps(1, end)",
          },
          "66.6667%": {
            transform: "translateY(-72px)",
            animationTimingFunction: "steps(1, end)",
          },
        },
        cardTransition: {
          0: { bottom: "-100%" },
          "100%": { bottom: "0%" },
        },
        wiggle: {
          "0%, 100%": { transform: "rotate(-3deg)" },
          "50%": { transform: "rotate(3deg)" },
        },

        horizontalShaking: {
          "0%": {
            transform: "translateX(0px)",
            animationTimingFunction: "cubic-bezier(0.65, 0, 0.35, 1)",
          },
          "14.285%": {
            transform: "translateX(-5px)",
            animationTimingFunction: "cubic-bezier(0.65, 0, 0.35, 1)",
          },
          "28.57%": {
            transform: "translateX(5px)",
            animationTimingFunction: "cubic-bezier(0.65, 0, 0.35, 1)",
          },
          "42.857%": {
            transform: "translateX(-5px)",
            animationTimingFunction: "cubic-bezier(0.65, 0, 0.35, 1)",
          },
          "57.14%": {
            transform: "translateX(5px)",
            animationTimingFunction: "cubic-bezier(0.65, 0, 0.35, 1)",
          },
          "71.428%": {
            transform: "translateX(-5px)",
            animationTimingFunction: "cubic-bezier(0.65, 0, 0.35, 1)",
          },
          "85.714%": {
            transform: "translateX(5px)",
            animationTimingFunction: "cubic-bezier(0.65, 0, 0.35, 1)",
          },
          "100%": {
            transform: "translateX(0px)",
            animationTimingFunction: "cubic-bezier(0.65, 0, 0.35, 1)",
          },
        },

        growDown: {
          "0%": { transform: "scaleY(0)" },
          "100%": { transform: "scaleY(1)" },
        },
        growUp: {
          "0%": { transform: "scaleY(1)" },
          "100%": { transform: "scaleY(0)" },
        },
        textTransition: {
          "0%": { opacity: "0%" },
          "80%": { opacity: "0%" },
          "100%": { opacity: "100%" },
        },
        textTransitionOff: {
          "0%": { opacity: "100%" },
          "20%": { opacity: "0%" },
          "100%": { opacity: "0%" },
        },
        dashCheck: {
          "0%": {
            strokeDashoffset: "100px",
          },
          "100%": {
            strokeDashoffset: "0px",
          },
        },
        ripple: {
          "0%": {
            opacity: "100%",
          },
          "50%": {
            opacity: "50%",
          },
          "100%": {
            opacity: "100%",
          },
        },
        wobble: {
          "0%": { transform: "translateX(0%)" },
          "15%": {
            transform: "translateX(-10%) rotate(-5deg)",
          },
          "30%": { transform: "translateX(10%) rotate(3deg) " },
          "45%": {
            transform: "translateX(-8%) rotate(-3deg)",
          },
          "60%": { transform: "translateX(8%) rotate(2deg)" },
          "75%": {
            transform: "translateX(-5%) rotate(-1deg)",
          },
          "100%": { transform: "translateX(0%)" },
        },
      }),
      fontSize: {
        body: "1rem",
        small: "0.85rem",
      },
      colors: {
        blue: {
          50: "#F1F2F4",
          100: "#F1F2F4",
          200: "#DAECFF",
          300: "#DAECFF",
          400: "#DAECFF",
          450: "#7fb8ff",
          500: "#BED4F0",
          550: "#BED4F0",
          600: "#006DF9CC",
          650: "#BED4F0",
          700: "#006DF9",
          750: "#006DF9",
          800: "#131dff",
          850: "#006DF9",
          900: "#006DF9",
          950: "#003cff",
          960: "#66A9FF",
          970: "#F5F9FF",
          primary_hover: "#005ED6",
          background_blue: "#EAEEF9",
        },
        grey: {
          0: "#FEFEFE",
          50: "#808080",
          100: "#B9BABC",
          200: "#B9BABC",
          300: "#8A8C8F",
          400: "#8A8C8F",
          450: "#565656",

          500: "#8A8C8F",
          550: "#8A8C8F",
          600: "#808080",
          650: "#343434",
          700: "#151A1F",
          750: "#151A1F",
          800: "#151A1F",
          850: "#151A1F",
          900: "#333333",
          950: "#212830",
        },
        green: {
          50: "#EFF4EF",
          100: "#EFF4EF",
          200: "#EFF4EF",
          300: "#EFF4EF",
          400: "#EFF4EF",
          500: "#EFF4EF",
          550: "#B8D1B4",
          600: "#B8D1B4",
          650: "#B8D1B4",
          700: "#6CB851",
          750: "#6CB851",
          800: "#6CB851",
          850: "#6CB851",
          900: "#6CB851",
          950: "#79A779",
          960: "#3A833A",
          success_page_bg: "#E8FDF2",
        },
        orange: {
          50: "#FEF2E9",
          100: "#FEF2E9",
          200: "#FEF2E9",
          300: "#E4BDA1",
          400: "#E4BDA1",
          500: "#E4BDA1",
          550: "#FDD4B6",
          600: "#FDD4B6",
          650: "#D88B54",
          700: "#D88B54",
          750: "#D88B54",
          800: "#D88B54",
          850: "#D88B54",
          900: "#D88B54",
          950: "#D88B54",
          960: "#E89519",
          border_orange: "#eea23640",
          warning_background_orange: "#eea2361a",
          warning_text_orange: "#EEA236",
        },
        mon: {
          100: "#0e0e0e",
        },
        red: {
          50: "#F9EDED",
          100: "#F9EDED",
          200: "#F9EDED",
          300: "#F9EDED",
          800: "#C04141",
          900: "#DA0E0F",
          950: "#F04849",
          960: "#EF6969",
          970: "#FF0000",
          980: "#FC5454",
          1000: "#A7A0A0",
          failed_page_bg: "#FDEDE8",
        },
        "error-red": "#DA0E0F",
        "status-green": "#36AF47",
        "popover-background": "#334264",
        "popover-background-hover": "#2E3B58",
        "status-text-orange": "#E9AA0A",
        "status-blue": "#0585DD",
        "status-yellow": "#F7981C",
        "status-gray": "#5B5F62",
        "table-violet": "#3D5BF00F",
        "table-border": "#EBEEFE",
        "progress-bar-red": "#ef6969",
        "progress-bar-blue": "#72b4f9",
        "progress-bar-orange": "#f7981c",
        "progress-bar-green": "#36af47",
        "security-tab-light-gray": "#d6d6ce",
        "security-tab-dark-gray": "#39373b",
        "border-light-grey": "#E6E6E6",
        light_blue_bg: "#F8FAFF",
        "light-grey": "#DFDFDF",
        "extra-light-grey": "#F0F2F4",
        "sidebar-blue": "#242F48",
        "profile-sidebar-blue": "#16488F",
        "jp-gray": {
          50: "#FAFBFD",
          100: "#F7F8FA",
          200: "#F1F5FA",
          250: "#FDFEFF",
          300: "#E7EAF1",
          350: "#F1F5FA",
          400: "#D1D4D8",
          450: "#FDFEFF",
          500: "#D8DDE9",
          600: "#CCCFD4",
          700: "#9A9FA8",
          800: "#67707D",
          850: "#31333A",
          870: "#6c6c6c",
          900: "#354052",
          950: "#202124",
          960: "#2C2D2F",
          970: "#1B1B1D",
          920: "#282A2F",
          930: "#989AA5",
          940: "#CCD2E2",
          980: "#ACADB8",
          dark_table_border_color: "#2e2f39",
          tabset_gray: "#f6f8f9",
          disabled_border: "#262626",
          table_hover: "#F9FBFF",
          darkgray_background: "#151A1F",
          lightgray_background: "#151A1F",
          text_darktheme: "#F6F8F9",
          lightmode_steelgray: "#CCD2E2",
          tooltip_bg_dark: "#F7F7FA",
          tooltip_bg_light: "#23211D",
          disable_heading_color: "#ACADB8",
          dark_disable_border_color: "#8d8f9a",
          light_table_border_color: "#CDD4EB",
          dark_background_hover: "#F8FAFC",
          no_data_border: "#6E727A",
          border_gray: "#354052",
          conflicts_light: "#f5f7fc",
          sankey_labels: "#7e828f",
          my_account_border: "#dfe2e5",
          dark_black: "#0E0E0E",
          banner_black: "#333333",
          back_light: "#6c6c6c",
          suboption_background_gray: "#212830",
          hover_color: "#2B3139",
          light_gray_bg: "#FAFAFA",
          divider_gray: "#B7B7B7",
          button_gray: "#F7F7F7",
          divider_gray: "#B7B7B7",
          border_gray: "#E8E8E8",
          secondary_hover: "#EEEEEE",
          test_credentials_bg: "#D9D9D959",
        },
        hyperswitch_dark_bg: "#212E46",
        hyperswitch_blue_bg: "#212E46",
        light_blue: "#006DF966",
        light_grey: "#454545",
        hyperswitch_green: "#71B44B",
        light_green: "#32AA52",
        hyperswitch_green_trans: "#71B44B20",
        hyperswitch_red: "#D7625B",
        hyperswitch_red_bg: "#F8E5E4",
        hyperswitch_background: "#F7F8FB",
        milestone_card_border: "#6DB852",
        pdf_background: "#F5F5F5",
        offset_white: "#FEFEFE",
        light_white: "#FFFFFF0D",
        unselected_white: "#9197A3",
        "infra-gray": {
          300: "#CCCCCC",
          700: "#3F3447",
          800: "#28212D",
          900: "#1A141F",
        },
        "infra-indigo": {
          50: "#E4E8FC10",
          100: "#E4E8FC15",
          200: "#E4E8FC47",
          300: "#E4E8FC64",
          400: "#E4E8FC87",
          500: "#E4E8FC",
          800: "#758AF0",
        },
        "infra-red": {
          600: "#FAABA6",
          900: "#F97F77",
        },
        "infra-amber": {
          600: "#F8D2A2",
          900: "#F9C077",
        },
        brown: {
          600: "#77612a",
        },
        yellow: {
          light_yellow: "#FFF5E1",
          pending_page_bg: "#FDF4DD",
        },
        "ardra-blue": {
          50: "#0E111E",
          100: "#13182C",
        },
        "ardra-gray": {
          200: "#5C6073",
        },
        "ardra-purple": "#7984E6",
        statusArdra: "#E6A779",
        statusCreated: "#5C6073",
      },
      fontSize: {
        "fs-10": "10px",
        "fs-11": "11px",
        "fs-13": "13px",
        "fs-14": "14px",
        "fs-16": "16px",
        "fs-18": "18px",
        "fs-20": "20px",
        "fs-24": "24px",
        "fs-28": "28px",
      },
      opacity: {
        3: "0.03",
      },
      borderWidth: {
        1: "1px",
        3: "3px",
      },
      boxShadow: {
        generic_shadow: "0 2px 5px 0 rgba(0, 0, 0, 0.12)",
        generic_shadow_dark: "0px 2px 5px 0 rgba(0, 0, 0, 0.78)",
        side_shadow: "0 4px 4px rgba(0, 0, 0, 0.25)",
        hyperswitch_box_shadow: "0 2px 8px 0px rgba(0,0,0,0.08)",
        checklistShadow: "-2px -4px 12px 0px rgba(0,0,0,0.11)",
        paymentLogsShadow: "0 0 4px 2px rgba(0,112,255,0.2)",
        sidebarShadow: "0 -2px 12px 0 rgba(0, 0, 0, 0.06)",
        connectorTagShadow: "0px 1px 4px 2px rgba(0, 0, 0, 0.06)",
        boxShadowMultiple:
          "2px -2px 24px 0px rgba(0, 0, 0, 0.04), -2px 2px 24px 0px rgba(0, 0, 0, 0.02)",
        homePageBoxShadow: "0px 2px 16px 2px rgba(51, 51, 51, 0.16)",
        sma: "0 1px 3px 0 rgb(0 0 0 / 0.05)",
      },
      gridTemplateColumns: {
        6: "repeat(6, minmax(0, 1fr))",
      },
      margin: {
        "10vh": "10vh",
        "20vh": "20vh",
      },
    },
  },
  variants: {},
  plugins: [
    plugin(function ({ addUtilities }) {
      const newUtilities = {
        "*::-webkit-scrollbar": {
          display: "none", // chrome and other
        },
        "*": {
          scrollbarWidth: "none", // firefox
        },
        ".show-scrollbar::-webkit-scrollbar": {
          display: "block",
          overflow: "scroll",
          height: "4px",
          width: "8px",
        },
        ".show-scrollbar::-webkit-scrollbar-thumb": {
          display: "block",
          borderRadius: "20rem",
          backgroundColor: "#8A8C8F",
        },
        ".show-scrollbar::-webkit-scrollbar-track": {
          backgroundColor: "#FFFFFFF",
        },
      };
      addUtilities(newUtilities);
    }),
  ],
};
