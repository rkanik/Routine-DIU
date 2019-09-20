<template>
  <div id="home" v-bind:class="{'light-colors':lightTheme}">
    <Sidebar class="sidebar"/>
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
import { bus } from "./main";
import dbRef from "./firebase/firebaseInit";
import Routines from "../data/json/routines/Fall2019/V2.json";
import Courses from "../data/json/Courses.json";
import Teachers from "../data/json/Teachers_DIU.json";
import axios from "axios";
import uniqid from "uniqid";

/* COMPORNENTS */
import Sidebar from "./components/layouts/Sidebar";
import Header from "./components/layouts/Header";
import Student from "./components/Student/Student";
import Teacher from "./components/Teacher/Teacher";
import EmptyRoom from "./components/EmptyRoom/EmptyRoom";
import Settings from "./components/Settings/Settings";
import Loader1 from "./components/Loaders/Loader1";

export default {
  name: "home",
  data() {
    return {
      tabActive: "Student",
      showLoading: true,
      lightTheme: false,
    };
  },
  components: {Sidebar,Header,Student,Teacher,Settings,Loader1,EmptyRoom},
  created() {

    /** Fetch Theme **/
    this.FetchTheme();
    bus.$on("ThemeChanged", x => this.FixTheme(x))

    /* SWITCHING BEETWEEN SIDEBAR TABS */
    bus.$on("Student", x => {this.tabActive = x})
    bus.$on("Teacher", x => {this.tabActive = x})
    bus.$on("EmptyRoom", x => {this.tabActive = x})
    bus.$on("Settings", x => {this.tabActive = x})
    bus.$on("SigninStudent", () => {this.tabActive = "Student";});

    /** SHOWING AND STOPING LOADINGS  */
    bus.$on("stopLoading", () => {this.showLoading = false;});
    bus.$on("showLoading", () => {this.showLoading = true;});

    /** EMITTING OBJERCT DATAS TO ALL COMPONENTS */
    setTimeout(() => {bus.$emit("Courses", Courses);bus.$emit("Routines", Routines);
      bus.$emit("Teachers", Teachers);
    }, 100);

    /** Get Client Info */
    this.GetClientInfo();

    /** Check device width and viewType for responsive */
    this.checkDeviceWidth();
    

  },
  methods: {
    checkDeviceWidth(){
        let width = (window.innerWidth > 0) ? window.innerWidth : screen.width;
        if(width<=576){localStorage.setItem("ViewType","Tab")}
    },
    SaveClientInfo(data, ref) {
        let userInfo = {
            ip: data.ip,isp: data.isp,latitude: data.latitude,
            longitude: data.longitude,city: data.city,
            post_code: data.postal_code,district: data.district,
            country: data.country_name,user_agent: navigator.userAgent,
            first_visited: new Date(),last_visited: new Date()
        };
        ref.set(userInfo);
    },
    async GetClientInfo() {
        let usageId = this.GetDocId();
        let docRes = await dbRef.collection("UsageHistory").doc(usageId).get();
        if (docRes.exists) {docRes.ref.update({ last_visited: new Date()})}
        else {
            let geoRes = await axios.get("https://json.geoiplookup.io/");
            let data = geoRes.data;
            this.SaveClientInfo(data, docRes.ref);
        }
    },
    GetDocId() {
      let usageId = "",locId = localStorage.getItem("usageId");
      if (locId) {usageId = locId;
      } else {usageId = uniqid();
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
        } else {this.FixTheme(false)}
      } else {this.FixTheme(false);}
    }
  }
};
</script>

<style lang="scss" scoped>

#home{
    // Default font //
    font-family: "Roboto", sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;

    color: #9e9e9e;
    display: grid;
    grid-template-columns: min-content auto;

    .hwr {
        background-color: #161616;
        .mcontainer {
            height: calc(100vh - 4rem);
            position: relative;
            overflow: auto;
            padding-bottom: 2rem;
            box-sizing: border-box;
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
        }
    }
}

::-webkit-scrollbar{width:4px}
::-webkit-scrollbar-track{background:#161616}
::-webkit-scrollbar-thumb{background:#00897b}
::-webkit-scrollbar-thumb:hover{background:#26a69a}

// Theming //
.bg-li-0 {
  background-color: #eceff1;
}
.light-colors{
    ::-webkit-scrollbar-track{background:#eceff1}
    .hwr {
        background-color: white !important;
        }
}

@media (max-width: 576px) {
    #home {
        display: unset;
        .mcontainer{
            width: 100%;
            padding-bottom: 1rem;
        }
    }
    .sidebar{
        display: none;
    }
}
</style>
