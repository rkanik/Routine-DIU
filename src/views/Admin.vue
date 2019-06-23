<template>
    <div id="Admin">
        <Loader2 v-if="loading2"/>
        <Signin v-if="isSignedIn===false"/>
        <div class="dashboard" v-if="isSignedIn">
            <Sidebar/>
            <div class="hwr">
                <Header/>
                <Loader v-if="loader"/>
                <div class="mcontainer pb-2">
                    <Students class="Students" v-bind:class="{showTab:tabActive==='Students'}"/>
                </div>
            </div>
        </div>
    </div>
</template>
<script>

/** IMPORTS */
import  {bus}   from '../main'
import  db      from "../js/firebaseInit"
import  firebase, { functions } from 'firebase/app'
import  'firebase/auth'
const auth = firebase.auth()

import  SemInfo     from "../json/SemesterInfo.json";
import  Summer19_V3 from "../../data/json/Summer19_Day_V3.json";
import  students from "../../data/json/AllStudents.json";

/* COMPONENTS */
import  Signin      from "../components/admin/Signin";
import  Loader      from "../components/subs/Loader1";
import  Loader2     from "../components/subs/Loader2";
import  Students    from "../components/admin/Students";
import  Sidebar     from "../components/admin/Sidebar";
import  Header      from "../components/admin/Header";
import { async } from 'q';

export default {
    name: "admin",
    components:{
        Signin,Loader2,Students,Sidebar,Header,Loader
    },
    data() {
        return {
            /** Booleans **/
            isSignedIn:undefined,loading2:true,loader:true,
            showStudents:false,

            /** Arrays **/
            Students:[],

            /** Strings */
            tabActive:'Students'
            
        };
    },
    created() {

        this.CheckSigninStatus();
        bus.$on('SignedIn',     ()  => {this.SigninAdmin()});
        bus.$on('LogoutAdmin',  ()  => this.LogoutAdmin());
        bus.$on('StartLoader',  ()  => this.loader=true);
        bus.$on('StopLoader',   ()  => this.loader=false);
        bus.$on('SelectedTab',  tab => this.tabActive = tab );

    },
    methods: {
        async FixAllStudents(){
            let sData = []
            let snaps = await db.collection('Students').get()
            snaps.forEach(doc=>{sData.push(doc.data())})
            
            let i = 0 ;   
            setInterval(() => {
                if( i < sData.length ){
                    db.collection('Students').doc(sData[i].ID).get()
                    .then( doc => {
                        doc.ref.update({
                            LastVisited:new Date(),
                            CreatedAt:new Date()
                        })
                    })
                    console.log(i,sData[i].ID,sData[i]);i++
                }
            }, 10000);
        },
        async GetAllStudents(){
            let Students = [];
            let res = await db.collection('Students').limit(100).get().
            res.forEach(doc=>{Students.push(doc.data())})
            this.exportToJsonFile(Students);
        },
        GetUniqueInitials(){
            let teachers = [];
            Object.keys(Summer19_V3).forEach( day => {
                if( day !== 'Labs' ){
                    Object.keys(Summer19_V3[day]).forEach( slot => {
                        Summer19_V3[day][slot].forEach( rout => {
                            if( rout.Teacher ){
                                teachers.push(rout.Teacher);
                            }
                        })
                    })
                }else{
                    Summer19_V3.Labs.forEach( rout => {
                        if( rout.Teacher ){
                            teachers.push(rout.Teacher);
                        }
                    })
                }
            })
            
            let disTeachers = teachers.filter((val, index, self) => {
                return self.indexOf(val) === index;
            })
            //this.exportToJsonFile(disTeachers);
        },
        OnFileSelected(event){
            let reader = new FileReader();
            reader.onload = function(ev){
                var obj = JSON.parse(ev.target.result);
            };
            reader.readAsText(event.target.files[0]);
        },
        UploadRoutine(){
            let docName = SemInfo.Semester+"_"+SemInfo.RoutineVersion;
            db.collection('Routines').doc(docName).set(Summer19_V3);
        },
        ReformatRoutine(){
            let days = ['Sat','Sun','Mon','Tue','Wed','Thu','Fri'];
            let slots = ['08-30','10-00','11-30','01-00','02-30','04-00'];
            let slotsFri = ['09-00','10-30','03-00','04-30'];

            Object.keys(Summer19_V3).forEach((day,di) => {
                if( day !== 'Labs' ){
                    Object.keys(Summer19_V3[day]).forEach( (slot, si) => {
                        let s = '';
                        if( day === 'Friday'){s = days[di]+"_"+slotsFri[si]
                        }else{s = days[di]+"_"+slots[si];}
                        Object.keys(cnvrtd[s]).forEach( key => {
                            Summer19_V3[day][slot].push(cnvrtd[s][key]);
                        })
                    })
                }
            })
            Summer19_V3.Labs = cnvrtd.Labs;
            this.exportToJsonFile(Summer19_V3);
        },
        exportToJsonFile(jsonData) {
            let dataStr = JSON.stringify(jsonData);
            let dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);    
            let exportFileDefaultName = 'data.json';    
            let linkElement = document.createElement('a');
            linkElement.setAttribute('href', dataUri);
            linkElement.setAttribute('download', exportFileDefaultName);
            linkElement.click();
        }, 
        CheckSigninStatus(){
            auth.onAuthStateChanged( user => {
                if(user){this.SigninAdmin();
                }else{this.LogoutAdmin();}
            });
        },
        SigninAdmin(){
            this.isSignedIn=true;
            this.StopLoading();
        },
        LogoutAdmin(){
            auth.signOut();
            this.isSignedIn=false;
            this.StopLoading();
        },
        StopLoading(){
            this.loading2=false;
        },
        fixCourses(){
            db.collection("Courses").get().then(ds=>{ds.forEach(doc => {
                let AllCourses = doc.data();
                db.collection('Students').get().then( das => {
                    das.forEach( stud => {
                        let sData = stud.data();
                        let codes = AllCourses[sData.Level+sData.Term].map(x=>{return x.Code+'('+sData.Section.toUpperCase()+')'})
                        sData.Courses = codes ;
                        stud.ref.update(sData);
                    })
                })

            });});
        }
    }
};
</script>

<style lang="scss" scoped>
    .dashboard{
        display: grid;
        grid-template-columns: min-content auto;
    }
    .mcontainer{
        height: calc(100vh - 4rem);
        position: relative;
    }
    .hwr{
        height: 100vh;
        background-color: #161616;
    }
    .Students{
        display: none;
    }
    .showTab{
        display: block;
    }
</style>
