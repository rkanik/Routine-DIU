<template>
  <div id="Student">
    <SignedBox v-if="isSignedIn" v-bind:signedData="signedData"/>
    <Teachers v-bind:teachers="teachers" v-if="comTeachers"/>
    <form
      class="se-ro-form"
      v-if="isSignedIn===false||showRSF"
      v-bind:class="{'light-colors':lightTheme}"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-3">
            <div class="form-group">
              <select class="form-control" v-model="Level">
                <option value="NONE">Select Level</option>
                <option value="L1">Level - 1</option>
                <option value="L2">Level - 2</option>
                <option value="L3">Level - 3</option>
                <option value="L4">Level - 4</option>
              </select>
            </div>
          </div>
          <div class="col-md-3">
            <div class="form-group">
              <select class="form-control" v-model="Term">
                <option value="NONE">Select Term</option>
                <option value="T1">Term - 1</option>
                <option value="T2">Term - 2</option>
                <option value="T3">Term - 3</option>
              </select>
            </div>
          </div>
          <div class="col-md-3">
            <div class="form-group">
              <input type="text" class="form-control" placeholder="Enter Section" v-model="Section">
            </div>
          </div>
          <div class="col-md-3">
            <button type="button" class="btn btn-outline-secondary btn-go" @click="onClickGo()">SHOW</button>
          </div>
        </div>
      </div>
    </form>
    <Overlaps v-if="overlaps.length>0" v-bind:overlaps="overlaps"/>
    <TableView
      v-if="viewType==='Table' && routineIsLoaded"
      v-bind:d="{slots:Slots,Routine:Routine}"
    />

    <div class="TabView" v-if="viewType==='Tab'" v-bind:class="{'light-colors':lightTheme}">
      <div class="container">
        <div class="row">
          <div class="col-md-2">
            <ul class="ul-tab" v-if="showClicked">
              <li
                class="tab"
                v-if="Routine[days[6]]"
                @click="onTabSelected(days[6])"
                v-bind:class="{active:dayOfWeek===days[6]}"
              >{{days[6]}}</li>
              <li
                class="tab"
                v-if="Routine[days[0]]"
                @click="onTabSelected(days[0])"
                v-bind:class="{active:dayOfWeek===days[0]}"
              >{{days[0]}}</li>
              <li
                class="tab"
                v-if="Routine[days[1]]"
                @click="onTabSelected(days[1])"
                v-bind:class="{active:dayOfWeek===days[1]}"
              >{{days[1]}}</li>
              <li
                class="tab"
                v-if="Routine[days[2]]"
                @click="onTabSelected(days[2])"
                v-bind:class="{active:dayOfWeek===days[2]}"
              >{{days[2]}}</li>
              <li
                class="tab"
                v-if="Routine[days[3]]"
                @click="onTabSelected(days[3])"
                v-bind:class="{active:dayOfWeek===days[3]}"
              >{{days[3]}}</li>
              <li
                class="tab"
                v-if="Routine[days[4]]"
                @click="onTabSelected(days[4])"
                v-bind:class="{active:dayOfWeek===days[4]}"
              >{{days[4]}}</li>
              <li
                class="tab"
                v-if="Routine[days[5]]"
                @click="onTabSelected(days[5])"
                v-bind:class="{active:dayOfWeek===days[5]}"
              >{{days[5]}}</li>
            </ul>
          </div>

          <div class="col-md-10">
            <div class="row">
              <div
                class="card mr-3 mb-3 col-md-3"
                v-for="r in Routine[dayOfWeek]"
                v-bind:key="r.Rime"
              >
                <div class="card-body">
                  <p class="card-text">{{r.Time}}</p>
                  <hr>
                  <h4 class="card-title">{{r.Title}}</h4>
                  <p class="card-text">{{r.Course}}</p>
                  <p class="card-text">{{r.Teacher}}</p>
                  <hr>
                  <p class="card-text">{{r.Room}}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <UpdateInfo v-if="updateModal" v-bind:data="updateData"/>
    <EditCourse v-if="showEditCourse"/>
  </div>
</template>

<script>
/** IMPORTS */
import { bus } from "../main";
import db from "../js/firebaseInit";
import days from "../json/DayOfWeeks.json";
import RoutineSlots from "../json/RoutineSlots.json";
import EmptyRoutine from "../json/EmptyRoutine.json";

/** COMPONENTS */
import TableView from "./subs/TableView";
import UpdateInfo from "./subs/UpdateInfo";
import EditCourse from "./subs/EditCourse";
import SignedBox from "./subs/SignedBox";
import Overlaps from "./subs/Overlaps";
import Teachers from "./subs/Teachers";

export default {
  name: "Student",
  components: {
    TableView,
    UpdateInfo,
    SignedBox,
    EditCourse,
    Overlaps,
    Teachers
  },
  data() {
    return {
      /** Booleans */
      lightTheme: false,
      updateModal: false,
      showEditCourse: false,
      showRSF: false,
      showClicked: false,
      routineIsLoaded: false,
      comTeachers: false,

      /** Objects */
      signedData: {},
      Routines: {},
      Courses: {},
      updateData: {},
      allTeachers: {},
      Routine: EmptyRoutine,

      /** Strings */
      Level: "NONE",
      Term: "NONE",
      Section: "",
      viewType: "",
      dayOfWeek: "",

      /** Unfefined */
      isSignedIn: undefined,

      /** Arrays */
      overlaps: [],
      teachers: [],
      days: days,
      Slots: RoutineSlots
      /*slotsRamadan:['09:30-10:25','10:25-11:20','11:20-12:15','12:15-01:10','01:40-02:35','02:35-03:30']*/
    };
  },
  created() {
    /** Fetch Theme **/
    this.FetchTheme();
    bus.$on("ThemeChanged", x => {
      this.FixTheme(x);
    });

    bus.$on("Courses", x => {
      this.Courses = x;
    });
    bus.$on("Routines", x => {
      this.Routines = x;
      this.fetchSessionData();
    });
    bus.$on("Teachers", x => {
      this.allTeachers = x;
    });
    bus.$on("SettingChanged", x => {
      this.OnSettingChanged(x);
    });

    /** Save or Update Info */
    bus.$on("SigninStudent", id => {
      this.SigninStudent(id);
    }); /** FROM HEADER */
    bus.$on("SaveStudent", () => {
      this.SaveStudent();
    }); /** FROM UPDATEINFO */
    bus.$on("UpdateStudent", () => {
      this.UpdateStudent();
    }); /** FROM UPDATEINFO */
    bus.$on("ClickedUpdate", () => {
      this.OnClickUpdate();
    }); /** FROM SIGNED BOX */
    bus.$on("CloseUpdateModal", () => {
      this.CloseUpdateModal();
    }); /** FROM UPDATEINFO */

    bus.$on("loggedOut", () => {
      this.onLoggedOut();
    });
    bus.$on("OnSignedIn", id => {
      this.OnSignedIn(id);
    });

    bus.$on("ShowRSF", () => {
      this.showRSF = true;
    });
    bus.$on("HideRSF", () => {
      this.showRSF = false;
      this.fetchSessionData();
    });

    /** EDIT COURSE MODAL */
    bus.$on("OnClickEditCourse", () => {
      this.showEditCourse = true;
    });
    bus.$on("UpdatedCourses", x => {
      this.UpdateCourses(x);
    });
    bus.$on("CloseEditCourse", () => {
      this.showEditCourse = false;
    });

    bus.$on("CollapseTeachers", () => {
      this.comTeachers = false;
    });
    bus.$on("ShowTeachers", () => {
      this.ShowTeachers();
    });

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
        this.isSignedIn = true;
        let data = JSON.parse(localStorage.signedData);
        this.signedData = data;
        this.UpdateLastVisited(data.ID);
        this.setRoutineLevelTermSection(data.Level, data.Term, data.Section);
        this.onClickGo();
      } else {
        this.isSignedIn = false;
        bus.$emit("stopLoading");
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
      let d = doc.data();
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
      db.collection("Students")
        .doc(id)
        .get()
        .then(doc => {
          if (doc.exists) {
            this.OnSignedIn(id, doc);
          } else {
            this.InitializeSaveModal(id);
          }
        });
    },
    InitializeSaveModal(id) {
      this.updateData = {
        ID: id,
        btn: "SAVE",
        Level: "NONE",
        Term: "NONE",
        Section: "",
        Name: "",
        Email: ""
      };
      this.updateModal = true;
    },
    onTabSelected(x) {
      this.dayOfWeek = x;
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
      let oSlots = [
        "08:30",
        "10:00",
        "11:30",
        "01:00",
        "02:30",
        "04:00",
        "05:30"
      ];
      this.showClicked = true;
      this.getDayOfWeek();
      this.Routine = {};
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
    onClickGo() {
      if (
        this.Level !== "NONE" &&
        this.Term !== "NONE" &&
        this.Section !== ""
      ) {
        this.overlaps = [];
        this.getViewType();
        let codes = this.getCourseCodes();
        if (this.viewType === "Table") {
          this.SetRoutineFor_TABLE_View(codes);
        } else if (this.viewType === "Tab") {
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
#Student {
  width: 100%;
  height: 100%;
}
.form-control {
  background-color: #161616 !important;
  border-color: #424242;
  color: #bdbdbd;
}
hr {
  padding: 0 !important;
}
.card {
  background-color: #202020;
  padding: 0 0.5rem;
  border: none;
  min-width: 14rem;
  .card-title {
    font-weight: 400;
  }
  hr {
    margin: 0.5rem 0;
    border-color: #1a1a1a;
  }
}
.lead {
  font-size: 1.1em;
}

.width100 {
  width: 100%;
  overflow: hidden;
}
.se-ro-form {
  padding-top: 1rem;
}
.btn-go {
  width: 100%;
  border-color: #424242;
  letter-spacing: 2px;
}
.TabView {
  margin-top: 1rem;
  .ul-tab {
    //: 1px solid #424242;
    padding-left: 0;
    .tab {
      list-style-type: none;
      margin-bottom: 0.5rem;
      padding: 0.34rem 0 0.3rem 1rem;
      border-radius: 2rem;
      cursor: pointer;
      color: #616161;
      user-select: none;
    }
    .active,
    .tab:hover {
      background-color: #202020;
      color: #a0a0a0;
    }
  }
}

// THEMEING //
.light-colors {
  .ul-tab {
    .tab {
      color: #424242;
    }
    .active,
    .tab:hover {
      background-color: white;
      color: #424242;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05), 0 1px 2px rgba(0, 0, 0, 0.1);
    }
  }
  .card {
    background-color: white;
    border: none;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05), 0 1px 2px rgba(0, 0, 0, 0.1);
    hr {
      border-color: #e0e0e0;
    }
    .card-title {
      color: #313131;
    }
    .card-text {
      color: #424242;
    }
  }
  .form-control {
    background-color: white !important;
    border-color: rgba(0, 0, 0, 0.1);
    color: #424242;
  }
  .btn-outline-secondary {
    border-color: rgba(0, 0, 0, 0.1);
    color: #424242;
  }
  .btn-outline-secondary:hover {
    background-color: #009688;
    color: white;
  }
}
.se-ro-form.light-colors {
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05), 0 1px 2px rgba(0, 0, 0, 0.1);
  background-color: white;
  border: none;
}
</style>
