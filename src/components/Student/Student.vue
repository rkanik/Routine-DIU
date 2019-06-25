<template>
    <div id="Student">

        <!-- this shows students info like name email level term and section -->
        <SignedBox v-if="isSignedIn" v-bind:signedData="signedData"/>

        <!-- Search form for search routine -->
        <SearchForm v-if="isSignedIn===false||showRSF" v-bind:d="{level:Level,term:Term,section:Section}"/>

        <!-- Component to show teachers of current semester -->
        <Teachers v-bind:teachers="teachers" v-if="comTeachers"/>

        <!-- Component to diplay overlaps if exist -->
        <Overlaps v-if="overlaps.length>0" v-bind:overlaps="overlaps"/>

        <!-- Component to diplay routine in Table format-->
        <TableView v-if="viewType==='Table' && routineIsLoaded" v-bind:d="{slots:Slots,Routine:Routine}" />
        
        <!-- Component to diplay routine in Tabs/Cards -->
        <TabView v-if="viewType=='Tab'" v-bind:d="{r:Routine,d:days,dow:dayOfWeek}"/>
        
        <!-- Component to signup and update student's info -->
        <UpdateInfo v-if="updateModal" v-bind:data="updateData"/>
        
        <!-- Component to edit student's courses -->
        <EditCourse v-if="showEditCourse"/>

    </div>
</template>

<script>
/** IMPORTS */
import  {bus}           from "../../main";
import  db              from "../../js/firebaseInit";
import  days            from "../../json/DayOfWeeks.json";
import  RoutineSlots    from "../../json/RoutineSlots.json";
import  EmptyRoutine    from "../../json/EmptyRoutine.json";

/** COMPONENTS */
import  TableView   from "../layouts/TableView";
import  TabView     from "../layouts/TabView";
import  UpdateInfo  from "./subs/UpdateInfo";
import  EditCourse  from "./subs/EditCourse";
import  SignedBox   from "./subs/SignedBox";
import  Overlaps    from "./subs/Overlaps";
import  Teachers    from "../layouts/Teachers";
import  SearchForm    from "./subs/SearchForm";

export default {
  name: "Student",
  components: {TableView,TabView,UpdateInfo,SignedBox,EditCourse,Overlaps,Teachers,SearchForm},
  data() {
    return {
        /** Booleans */
        lightTheme:       false,    updateModal:      false,
        showEditCourse:   false,    showRSF:          false,
        showClicked:      false,    routineIsLoaded:  false,
        comTeachers:      false,

        /** Objects */
        signedData:     {},     Routines:   {},
        Courses:        {},     updateData: {},
        allTeachers:    {},     Routine: EmptyRoutine,

        /** Strings */
        Level:      "NONE",     Term:       "NONE",
        Section:    "",         viewType:   "",
        dayOfWeek:  "",

        /** Unfefined */
        isSignedIn: undefined,

        /** Arrays */
        overlaps:   [],     teachers:   [],
        days: days,         Slots: RoutineSlots
        /*slotsRamadan:['09:30-10:25','10:25-11:20','11:20-12:15','12:15-01:10','01:40-02:35','02:35-03:30']*/
    };
  },
  created() {

    bus.$on("Courses", x => { this.Courses = x; });
    bus.$on("Routines", x => { this.Routines = x; this.fetchSessionData(); });
    bus.$on("Teachers", x => { this.allTeachers = x; });
    bus.$on("SettingChanged", x => { this.OnSettingChanged(x); });

    /** Save or Update Info */
    bus.$on("SigninStudent", id => { this.SigninStudent(id); }); /** FROM HEADER */
    bus.$on("SaveStudent", () => { this.SaveStudent(); }); /** FROM UPDATEINFO */
    bus.$on("UpdateStudent", () => { this.UpdateStudent(); }); /** FROM UPDATEINFO */
    bus.$on("ClickedUpdate", () => { this.OnClickUpdate(); }); /** FROM SIGNED BOX */
    bus.$on("CloseUpdateModal", () => { this.CloseUpdateModal(); }); /** FROM UPDATEINFO */

    bus.$on("loggedOut", () => { this.onLoggedOut(); });
    bus.$on("OnSignedIn", id => { this.OnSignedIn(id); });

    bus.$on("ShowRSF", () => { this.showRSF = true; });
    bus.$on("HideRSF", () => { this.showRSF = false; this.fetchSessionData(); });

    bus.$on('SearchFormData', d => {
        this.setRoutineLevelTermSection(d.level,d.term,d.section.toUpperCase())
        this.onClickGo()
    })

    /** EDIT COURSE MODAL */
    bus.$on("OnClickEditCourse", () => {this.showEditCourse = true;});
    bus.$on("UpdatedCourses", x => {this.UpdateCourses(x);});
    bus.$on("CloseEditCourse", () => {this.showEditCourse = false;});
    bus.$on("CollapseTeachers", () => {this.comTeachers = false;});
    bus.$on("ShowTeachers", () => {this.ShowTeachers();});

    this.getDayOfWeek();
  },
  methods: {
    UpdateCourses(courses) {
      let match = 0;
      courses.forEach(course => {
        if (this.signedData.Courses.includes(course)) {
          match++;
        }
      });
      if (
        courses.length !== this.signedData.Courses ||
        match !== courses.length
      ) {
        this.signedData.Courses = courses;
        this.setSignedSessionData(this.signedData);
        this.onClickGo();
        db.collection("Students")
          .doc(this.signedData.ID)
          .get()
          .then(doc => doc.ref.update({ Courses: courses }));
      }
      this.showEditCourse = false;
    },
    IsLevelTermChanged() {
      let s = this.signedData,
        u = this.updateData,
        changed = false;
      if (s.Term !== u.Term || s.Level !== u.Level) {
        changed = true;
      }
      return changed;
    },
    IsUpdateValueChanged() {
      let changed = false;
      for (const key in this.updateData) {
        if (this.updateData[key] !== this.signedData[key]) {
          changed = true;
        }
      }
      return changed;
    },
    FinishUpdateStudent() {
      for (const key in this.updateData) {
        this.signedData[key] = this.updateData[key];
      }
      this.setSignedSessionData(this.signedData);
      this.setRoutineLevelTermSection(
        this.signedData.Level,
        this.signedData.Term,
        this.signedData.Section
      );
      this.onClickGo();
      this.updateModal = false;

      this.updateData.LastVisited = new Date();
      db.collection("Students")
        .doc(this.updateData.ID)
        .get()
        .then(doc => {
          if (doc.data().CreatedAt) {
            this.updateData.CreatedAt = doc.data().CreatedAt;
          } else {
            this.updateData.CreatedAt = new Date().toUTCString();
          }
          doc.ref.update(this.updateData);
        });
    },
    async UpdateStudent() {
      delete this.updateData.btn;
      if (this.IsUpdateValueChanged()) {
        this.updateData.Section = this.updateData.Section.toUpperCase();
        if (this.IsLevelTermChanged()) {
          this.updateData.Courses = this.Courses[
            this.updateData.Level + this.updateData.Term
          ].map(x => {
            return x.Code + "(" + this.updateData.Section + ")";
          });
        } else if (this.signedData.Section !== this.updateData.Section) {
          let curCourses = this.Courses[
            this.updateData.Level + this.updateData.Term
          ].map(x => {
            return x.Code + "(" + this.updateData.Section + ")";
          });
          let prevRegCourses = this.Courses[
            this.signedData.Level + this.signedData.Term
          ].map(x => {
            return x.Code + "(" + this.signedData.Section + ")";
          });
          let prevCourses = this.signedData.Courses;
          prevCourses.forEach(course => {
            if (!prevRegCourses.includes(course)) {
              curCourses.push(course);
            }
          });
          this.updateData.Courses = curCourses;
        }
        this.FinishUpdateStudent();
      } else {
        this.updateModal = false;
      }
    },
    async SaveStudent() {
      this.updateData.Section = this.updateData.Section.toUpperCase();
      this.updateData.Courses = this.Courses[
        this.updateData.Level + this.updateData.Term
      ].map(x => {
        return x.Code + "(" + this.updateData.Section + ")";
      });
      this.updateData.LastVisited = this.updateData.CreatedAt = new Date();
      delete this.updateData.btn;
      await db
        .collection("Students")
        .doc(this.updateData.ID)
        .set(this.updateData);
      this.SigninStudent(this.updateData.ID);
      this.updateModal = false;
      this.updateData = {};
    },
    GetTeacherInitials() {
      let teacherInitials = [];
      for (const day in this.Routine) {
        this.Routine[day].forEach(rout => {
          if (rout.Teacher && !teacherInitials.includes(rout.Teacher)) {
            teacherInitials.push(rout.Teacher);
          }
        });
      }
      return teacherInitials;
    },
    ShowTeachers() {
      this.teachers = [];
      let initials = this.GetTeacherInitials();
      this.allTeachers.forEach(teacher => {
        initials.forEach(initial => {
          if (teacher.Initial === initial) {
            this.teachers.push(teacher);
          }
        });
      });
      this.comTeachers = true;
    },
    OnSettingChanged(x) {
      if (x === "ViewType") {
        this.viewType = localStorage.getItem("ViewType");
        this.onClickGo();
      }
    },
    CloseUpdateModal() {
      this.updateData = {};
      this.updateModal = false;
      bus.$emit("stopLoading");
    },
    OnClickUpdate() {
      let d = this.signedData;
      this.updateData = {
        ID: d.ID,
        btn: "UPDATE",
        Level: d.Level,
        Term: d.Term,
        Section: d.Section,
        Name: d.Name,
        Email: d.Email
      };
      this.updateModal = true;
    },
    onLoggedOut() {
      bus.$emit("showLoading");
      this.isSignedIn = false;
      this.signedData = {};
      this.updateData = {};
      localStorage.removeItem("isSignedIn");
      localStorage.removeItem("signedData");
      this.routineIsLoaded = false;
      this.ResetLevelTermAndSection();
      this.overlaps = [];
      this.ResetRoutine();
    },
    ResetLevelTermAndSection() {
      (this.Level = "NONE"), (this.Term = "NONE"), (this.Section = "");
      bus.$emit("stopLoading");
    },
    fetchSessionData() {
        if (localStorage.isSignedIn) {
            this.isSignedIn = true; let data = JSON.parse(localStorage.signedData);
            this.signedData = data;this.UpdateLastVisited(data.ID);
            this.setRoutineLevelTermSection(data.Level, data.Term, data.Section);
            this.onClickGo(); 
        } else {
            this.syncUserState();
            this.isSignedIn = false;
            bus.$emit("stopLoading");
        }
    },
    syncUserState(){
        if( localStorage.usageData ){
            let d = JSON.parse(localStorage.usageData)
            this.setRoutineLevelTermSection(d.level,d.term,d.section);
            this.onClickGo()
        }
    },
    getViewType() {
      if (localStorage.getItem("ViewType")) {
        this.viewType = localStorage.getItem("ViewType");
      } else {
        localStorage.setItem("ViewType", "Table");
        this.getViewType();
      }
    },
    UpdateLastVisited(id) {
      db.collection("Students")
        .doc(id)
        .get()
        .then(doc => doc.ref.update({ LastVisited: new Date() }));
    },
    OnSignedIn(id, doc) {
      doc.ref.update({ LastVisited: new Date() });
      let d = doc.data();localStorage.removeItem('usageData')
      this.fixViewsAndDatas(d);
      bus.$emit("signedData", d);
      this.setSignedSessionData(d);
      this.setRoutineLevelTermSection(d.Level, d.Term, d.Section);
      this.onClickGo();
      this.updateModal = false;
      bus.$emit("stopLoading");
      this.updateData = {};
    },
    fixViewsAndDatas(data) {
      this.signedData = data;
      this.isSignedIn = true;
      this.showRSF = false;
    },
    setRoutineLevelTermSection(level, term, section) {
      this.Level = level;
      this.Term = term;
      this.Section = section;
    },
    setSignedSessionData(data) {
      localStorage.removeItem("signedData");
      localStorage.setItem("isSignedIn", true);
      localStorage.setItem("signedData", JSON.stringify(data));
    },
    SigninStudent(id) {
      db.collection("Students").doc(id).get()
        .then(doc => {
          if (doc.exists) {
            this.OnSignedIn(id, doc);
          } else {
            this.InitializeSaveModal(id);
          }
        });
    },
    InitializeSaveModal(id) {
      this.updateData = {ID: id,btn: "SAVE",Level: "NONE",Term: "NONE",Section: "",Name: "",Email: ""};
      this.updateModal = true;
    },
    getDayOfWeek() {
      let date = new Date();
      this.dayOfWeek = this.days[date.getDay()];
    },
    ResetRoutine() {
      if (this.viewType === "Table") {
        this.Routine = {
          Saturday: [{}, {}, {}, {}, {}, {}],
          Sunday: [{}, {}, {}, {}, {}, {}],
          Monday: [{}, {}, {}, {}, {}, {}],
          Tuesday: [{}, {}, {}, {}, {}, {}],
          Wednesday: [{}, {}, {}, {}, {}, {}],
          Thursday: [{}, {}, {}, {}, {}, {}],
          Friday: [],
          Labs: []
        };
      } else {
        this.Routine = {};
      }
      this.routineIsLoaded = false;
    },
    getCourseCodes() {
      if (!this.isSignedIn || this.showRSF) {
        return this.Courses[this.Level + this.Term].map(x => {
          return x.Code + "(" + this.Section.toUpperCase() + ")";
        });
      } else {
        return this.signedData.Courses;
      }
    },
    RemoveOffDayFromRoutine(day) {
      let emptyDay = 0;
      this.Routine[day].forEach(r => {
        if (!r.Course) {
          emptyDay++;
        }
        if (emptyDay === 6) {
          this.Routine[day] = [];
        }
      });
    },
    SetRoutineFor_TABLE_View(codes) {
      let oSlots = ["08:30", "10:00", "11:30", "01:00", "02:30", "04:00"];
      this.ResetRoutine();
      for (const day in this.Routines) {
        if (day !== "Labs") {
          for (const slot in this.Routines[day]) {
            this.Routines[day][slot].forEach(routine => {
              codes.forEach(code => {
                if (code === routine.Course) {
                  routine.Title = this.getCourseTitle(code.split("(")[0]);
                  routine.Time = slot;
                  if (!this.CheckForOverlab(day, routine.Time, routine)) {
                    if (day !== "Friday") {
                      let ind = oSlots.indexOf(slot);
                      this.Routine[day].splice(ind, 1, routine);
                    } else {
                      routine.Day = day;
                      this.Routine[day].push(routine);
                    }
                  }
                }
              });
            });
          }
        } else {
          this.Routines.Labs.forEach(r => {
            codes.forEach(code => {
              if (code === r.Course) {
                r.Title = this.getCourseTitle(code.split("(")[0]);
                this.Routine.Labs.push(r);
              }
            });
          });
        }
        this.RemoveOffDayFromRoutine(day);
      }
      this.routineIsLoaded = true;
    },
    SetRoutineFor_TAB_View(codes) {
      let oSlots = ["08:30","10:00","11:30","01:00","02:30","04:00","05:30"];
      this.showClicked = true;this.getDayOfWeek();this.Routine = {};
      for (const day in this.Routines) {
        if (day !== "Labs") {
          for (const slot in this.Routines[day]) {
            this.Routines[day][slot].forEach(routine => {
              codes.forEach(code => {
                if (code === routine.Course) {
                  routine.Title = this.getCourseTitle(code.split("(")[0]);
                  let i = oSlots.indexOf(slot);
                  if (day !== "Friday") {
                    routine.Time = slot + "-" + oSlots[i + 1];
                  } else {
                    routine.Time = slot;
                  }
                  if (!this.CheckForOverlab(day, routine.Time, routine)) {
                    if (this.Routine[day]) {
                      this.Routine[day].push(routine);
                    } else {
                      this.Routine[day] = [routine];
                    }
                  }
                }
              });
            });
          }
        } else {
          this.Routines.Labs.forEach(lab => {
            codes.forEach(code => {
              if (code === lab.Course) {
                lab.Title = this.getCourseTitle(code.split("(")[0]);
                if (this.Routine[lab.Day]) {
                  this.Routine[lab.Day].push(lab);
                } else {
                  this.Routine[lab.Day] = [lab];
                }
              }
            });
          });
        }
        if (day === this.dayOfWeek && !this.Routine[day]) {
          this.Routine[day] = [
            {
              Title: "There is no Class Today",
              Time: "It's holiday!",
              Room: "Enjoy your day"
            }
          ];
        }
      }
      this.routineIsLoaded = true;
    },
    checkForUsageData(){
        if( !this.isSignedIn ){
            let data = {level:this.Level,term:this.Term,section:this.Section}
            localStorage.setItem('usageData',JSON.stringify(data))
        }
    },
    onClickGo() {
        if ( this.Level !== "NONE" && this.Term !== "NONE" && this.Section !== "" ) {
            this.checkForUsageData()
            this.overlaps = []; this.getViewType();
            let codes = this.getCourseCodes();
            if (this.viewType === "Table") {
                this.SetRoutineFor_TABLE_View(codes);
            }
            else if (this.viewType === "Tab") {
                this.SetRoutineFor_TAB_View(codes);
            }
            bus.$emit("stopLoading");
      } else {
        this.ResetRoutine();
      }
    },
    FixRamadanTime(day) {
      if (day !== "Labs") {
        this.Routine[day].forEach(el => {
          switch (el.Time) {
            case this.Slots[0]:
              el.Time = this.slotsRamadan[0];
              break;
            case this.Slots[1]:
              el.Time = this.slotsRamadan[1];
              break;
            case this.Slots[2]:
              el.Time = this.slotsRamadan[2];
              break;
            case this.Slots[3]:
              el.Time = this.slotsRamadan[3];
              break;
            case this.Slots[4]:
              el.Time = this.slotsRamadan[4];
              break;
            case this.Slots[5]:
              el.Time = this.slotsRamadan[5];
              break;
            default:
              break;
          }
        });
      }
    },
    CheckForOverlab(day, time, routine) {
      let overlap = false;
      if (this.Routine[day]) {
        this.Routine[day].forEach(el => {
          if (el.Time === time) {
            el.Day = day;
            this.overlaps.push([el, routine]);
            overlap = true;
          }
        });
      }
      return overlap;
    },
    PushEmptyRoutineAtEnd(day) {
      if (day !== "Labs" && day !== "Friday") {
        if (this.Routine[day].length !== 0) {
          for (let index = this.Routine[day].length; index < 6; index++) {
            this.Routine[day].push(this.Slots[index]);
          }
        }
      }
    },
    PushEmptyRoutineInside(day) {
      let i = 0;
      while (i < 6) {
        if (day !== "Labs" && day !== "Friday") {
          //console.log(day);
          this.Routine[day].forEach((e, index) => {
            if (e.Time !== this.Slots[index]) {
              this.Routine[day].splice(index, 0, { Time: this.Slots[index] });
            }
          });
        }
        i++;
      }
    },
    getCourseTitle(code) {
      let title = "";
      this.Courses[this.Level + this.Term].forEach(el => {
        if (code === el.Code) {
          title = el.Title;
        }
      });
      if (title === "") {
        for (const key in this.Courses) {
          this.Courses[key].forEach(el => {
            if (code === el.Code) {
              title = el.Title;
            }
          });
        }
      }
      return title;
    }
  }
};
</script>