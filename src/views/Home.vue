<template>
  <div class="home">
    <Sidebar/>
    <div class="hwr" v-bind:class="{'bg-li-0':lightTheme}">
      <Header/>
      <div class="mcontainer">
        <Loader1 v-if="showLoading"/>
        <Student class="Student" v-bind:class="{tabActive:tabActive==='Student'}"/>
        <Teacher class="Teacher" v-bind:class="{tabActive:tabActive==='Teacher'}"/>
        <EmptyRoom class="EmptyRoom" v-bind:class="{tabActive:tabActive==='EmptyRoom'}"/>
        <Settings v-if="tabActive==='Settings'"/>
      </div>
    </div>
  </div>
</template>

<script>
/* IMPORTS */
import { bus } from "../main";
import dbRef from "../js/firebaseInit";
import Routines from "../../data/json/Summer19_Day_V3.json";
import Courses from "../../data/json/Courses.json";
import Teachers from "../../data/json/Teachers_DIU.json";
import axios from "axios";
import uniqid from "uniqid";

/* COMPORNENTS */
import Sidebar from "../components/Sidebar";
import Header from "../components/Header";
import Student from "../components/Student";
import Teacher from "../components/Teacher";
import EmptyRoom from "../components/EmptyRoom";
import Settings from "../components/Settings";
import Loader1 from "../components/subs/Loader1";

export default {
  name: "home",
  data() {
    return {
      tabActive: "Student",
      showLoading: true,
      lightTheme: false,
      deviceIp: ""
    };
  },
  components: {
    Sidebar,
    Header,
    Student,
    Teacher,
    Settings,
    Loader1,
    EmptyRoom
  },
  created() {
    /** Fetch Theme **/
    this.FetchTheme();
    bus.$on("ThemeChanged", x => {
      this.FixTheme(x);
    });

    /* SWITCHING BEETWEEN SIDEBAR TABS */
    bus.$on("Student", x => {
      this.tabActive = x;
    });
    bus.$on("Teacher", x => {
      this.tabActive = x;
    });
    bus.$on("EmptyRoom", x => {
      this.tabActive = x;
    });
    bus.$on("Settings", x => {
      this.tabActive = x;
    });
    bus.$on("SigninStudent", x => {
      this.tabActive = "Student";
    });

    /** SHOWING AND STOPING LOADINGS  */
    bus.$on("stopLoading", () => {
      this.showLoading = false;
    });
    bus.$on("showLoading", () => {
      this.showLoading = true;
    });

    /** EMITTING OBJERCT DATAS TO ALL COMPONENTS */
    setTimeout(() => {
      bus.$emit("Courses", Courses);
      bus.$emit("Routines", Routines);
      bus.$emit("Teachers", Teachers);
    }, 100);
    this.GetClientInfo();
  },
  methods: {
    GetLocalIP() {
      return new Promise(function(resolve, reject) {
        var RTCPeerConnection =
          window.webkitRTCPeerConnection || window.mozRTCPeerConnection;
        RTCPeerConnection || reject("Your browser does not support this API");
        var rtc = new RTCPeerConnection({ iceServers: [] }),
          addrs = {};
        function grepSDP(e) {
          var n = "";
          return (
            e.split("\r\n").forEach(function(e) {
              if (~e.indexOf("a=candidate")) {
                var r = (t = e.split(" "))[4];
                "host" === t[7] && (n = r);
              } else if (~e.indexOf("c=")) {
                var t;
                r = (t = e.split(" "))[2];
                n = r;
              }
            }),
            n
          );
        }
        (addrs["0.0.0.0"] = !1),
          rtc.createDataChannel("", { reliable: !1 }),
          (rtc.onicecandidate = function(e) {
            if (e.candidate) {
              var n = grepSDP("a=" + e.candidate.candidate);
              resolve(n);
            }
          }),
          rtc.createOffer(
            function(e) {
              rtc.setLocalDescription(e);
            },
            function(e) {
              console.warn("offer failed", e);
            }
          );
      });
    },
    SaveClientInfo(data, ref) {
      let userInfo = {
        ip: data.deviceIp,
        routIp: data.ip,
        isp: data.isp,
        latitude: data.latitude,
        longitude: data.longitude,
        city: data.city,
        post_code: data.postal_code,
        district: data.district,
        country: data.country_name,
        user_agent: navigator.userAgent,
        first_visited: new Date(),
        last_visited: new Date()
      };
      ref.set(userInfo);
    },
    async GetClientInfo() {
      let usageId = this.GetDocId();
      let docRes = await dbRef
        .collection("UsageHistory")
        .doc(usageId)
        .get();
      if (docRes.exists) {
        docRes.ref.update({ last_visited: new Date() });
      } else {
        let geoRes = await axios.get("https://json.geoiplookup.io/");
        let data = geoRes.data;
        if (ipRes) {
          data.deviceIp = ipRes;
        } else {
          data.deviceIp = "";
        }
        this.SaveClientInfo(data, docRes.ref);
      }
    },
    GetDocId() {
      let usageId = "",
        locId = localStorage.getItem("usageId");
      if (locId) {
        usageId = locId;
      } else {
        usageId = uniqid();
        localStorage.setItem("usageId", usageId);
      }
      return usageId;
    },
    FixTheme(x) {
      this.lightTheme = x;
      localStorage.setItem("Theme", x);
    },
    FetchTheme() {
      if (localStorage.getItem("Theme") !== undefined) {
        if (localStorage.getItem("Theme") === "true") {
          this.FixTheme(true);
        } else {
          this.FixTheme(false);
        }
      } else {
        this.FixTheme(false);
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.home {
  display: grid;
  grid-template-columns: min-content auto;
}
.mcontainer {
  height: calc(100vh - 4rem);
  position: relative;
  overflow: auto;
  padding-bottom: 2rem;
  box-sizing: border-box;
}
.hwr {
  background-color: #161616;
}
.Student,
.Teacher,
.EmptyRoom {
  display: none;
}
.EmptyRoom {
  height: 90%;
}
.tabActive {
  display: block;
}

// Theming //
.bg-li-0 {
  background-color: #eceff1;
}
</style>
