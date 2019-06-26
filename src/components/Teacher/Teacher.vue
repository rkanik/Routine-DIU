<template>
    <div class="teacher pt-4" v-bind:class="{'light-colors':lightTheme}">
        <div class="container">
            <div class="input-group">
                <input type="text" @keyup="OnChangeSearchKey" v-model="searchedKey" class="form-control" placeholder="Teacher's name or initial" aria-describedby="button-addon2">
                <div class="input-group-append">
                    <button class="btn btn-outline-secondary" @click="InitTeacherRoutine(searchedKey)" type="button" id="button-addon2">SEARCH</button>
                </div>
            </div>
            <TeacherSuggs v-if="filteredSugg.length>0" v-bind:suggs="filteredSugg"/>
            <hr>
            <Teachers  v-bind:teachers="teacherInfo" v-if="teacherFound"/>

            <!-- Component to diplay routine in Table format-->
            <TableView v-if="viewType==='Table'&&routineLoaded" v-bind:d="{slots:Slots,Routine:Routine}" />
            
            <!-- Component to diplay routine in Tabs/Cards -->
            <TabView v-if="viewType=='Tab'&&routineLoaded" v-bind:d="{r:Routine,d:daysOfWeek,dow:today}"/>

        </div>
    </div>
</template>
<script>
/* IMPORTS */
import { bus } from "../../main";
import RoutineSlots from "../../json/RoutineSlots.json";

/** COMPONENTS */
import Teachers from "../layouts/Teachers";
import TeacherSuggs from "./subs/TeacherSuggs";
import TableView from "../layouts/TableView"
import TabView from "../layouts/TabView"

export default {
    name:"Teacher",
    data(){
        return{

            /** Strings */
            searchedKey:'',     viewType:'Table',
            today:"",

            /** Objects */
            Routines:{},courses:{},
            Routine:{},
            Slots:RoutineSlots,
            
            /** Arrays */
            teachers:[], teacherInfo:[],
            suggestions:[],filteredSugg:[],
            daysOfWeek:[],

            /** Booleans */
            teacherFound:false,routineLoaded:false,
            lightTheme:false,
        }
    },
    components:{Teachers,TeacherSuggs,TableView,TabView},
    created(){
        this.FetchTheme();
        bus.$on('ThemeChanged',x=>this.FixTheme(x))
        bus.$on('Routines', x =>{this.Routines=x})
        bus.$on('Courses', x =>{this.courses=x})
        bus.$on('Teachers', x =>{this.teachers=x;this.GenerateSuggestions()})

        bus.$on('SearchedKey',key=>{this.InitTeacherRoutine(key)})
    },
    methods:{
        getViewType(){let viewType='';localStorage.ViewType?viewType=localStorage.getItem('ViewType'):viewType='';return viewType;},
        InitTeacherRoutine(key){
            this.filteredSugg=[];this.searchedKey=key
            this.teachers.forEach( teacher => {
                if(teacher.Name===key&&teacher.Initial){
                    key=teacher.Initial
                }
            })
            this.onClickGo(key)
        },
        OnChangeSearchKey(event){
            if(event.keyCode===13){
                this.InitTeacherRoutine(event.target.value)
            }else{
                let suggs =this.FilteredSugg
                if(suggs.length>8){suggs=suggs.slice(0,8)}
                this.filteredSugg=suggs
            }
        },
        GenerateSuggestions(){
            this.teachers.forEach(teacher=>{if(teacher.Initial)this.suggestions.push(teacher.Initial)})
            this.teachers.forEach(teacher=>{if(teacher.Name)this.suggestions.push(teacher.Name)})
        },
        RemoveOffDayFromRoutine(day){
            let emptyDay = 0 ;
            this.Routine[day].forEach( r => {
                if( !r.Course ){emptyDay++;}
                if( emptyDay === 6 ){
                    this.Routine[day]=[];
                }
            })
        },
        getDaysOfWeek(){return["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]},
        getDayOfWeek(){return this.getDaysOfWeek()[new Date().getDay()]},
        getEmptyRoutine(){return {"Saturday":[{},{},{},{},{},{}],"Sunday":[{},{},{},{},{},{}],"Monday":[{},{},{},{},{},{}],"Tuesday":[{},{},{},{},{},{}],"Wednesday":[{},{},{},{},{},{}],"Thursday":[{},{},{},{},{},{}],"Friday":[{},{},{},{},{},{}],"Labs":[]}},
        ResetRoutine(){
            this.Routine = {
                "Saturday": [{},{},{},{},{},{}],
                "Sunday": [{},{},{},{},{},{}],
                "Monday": [{},{},{},{},{},{}],
                "Tuesday": [{},{},{},{},{},{}],
                "Wednesday": [{},{},{},{},{},{}],
                "Thursday": [{},{},{},{},{},{}],
                "Friday": [{},{},{},{},{},{}],
                "Labs": []
            }
        },
        GetTeacherInfo(key){
            this.teacherInfo=[];
            this.teachers.forEach(teacher=>{
                if(teacher.Initial&&teacher.Initial===key.toUpperCase()){
                    this.teacherInfo.push(teacher);
                    this.teacherFound=true;
                }
            })
        },
        getShortSlots(){return ["08:30","10:00","11:30","01:00","02:30","04:00","05:30"]},
        async SetRoutineFor_TAB_View(key){
            this.daysOfWeek=this.getDaysOfWeek();this.today=this.getDayOfWeek();this.Routine={};
            for(let day in this.Routines){if(day!=='Labs'){
                for(let slot in this.Routines[day]){
                    this.Routines[day][slot].forEach(routine=>{
                        if(routine.Teacher===key.toUpperCase()){
                            let slots = this.getShortSlots(),slotIndex =  slots.indexOf(slot)
                            routine.Time=slots[slotIndex]+'-'+slots[slotIndex+1]
                            routine.Title=this.getCourseTitle(routine.Course.split('(')[0])
                            this.Routine[day]?this.Routine[day].push(routine):this.Routine[day]=[routine];
                        }
                    })
                }}
                else{
                    this.Routines.Labs.forEach(routine=>{
                        if(routine.Teacher===key){
                            routine.Time=''
                            this.Routine[routine.Day]?this.Routine[routine.Day].push(routine):this.Routine[routine.Day]=[routine];
                        }
                    })
                }
                if( day===this.today && !this.Routine[day]) {
                    this.Routine[day] = [{
                        Title: "Teacher don't have any class today",
                        Time: "It's holiday!",
                        Room: "Enjoy your day"
                    }]
                }
            }
            this.routineLoaded=true;
        },
        SetRoutineFor_TABLE_View(key){
            let oSlots = this.getShortSlots();this.Routine = this.getEmptyRoutine();
            for( let day in this.Routines ){if( day !== 'Labs' ){
                for( let slot in this.Routines[day]){
                    this.Routines[day][slot].forEach( routine => {
                        if( routine.Teacher === key.toUpperCase() ){
                            let ind = oSlots.indexOf(slot);
                            this.Routine[day].splice(ind,1,routine);
                        }
                    })
                }
            }else{
                this.Routines.Labs.forEach( rout => {
                    if( rout.Teacher === key.toUpperCase() ){
                        rout.Title = this.getCourseTitle(rout.Course.split('(')[0]);
                        this.Routine.Labs.push(rout);
                    }
                })}
                this.RemoveOffDayFromRoutine(day)
            }
        },
        onClickGo(key){
            bus.$emit("showLoading");this.GetTeacherInfo(key)
            this.viewType=this.getViewType();
            if (this.viewType === "Table") {
                this.SetRoutineFor_TABLE_View(key);
            }
            else if (this.viewType === "Tab") {
                this.SetRoutineFor_TAB_View(key);
            }
            this.routineLoaded=true
            bus.$emit("stopLoading");
        },
        getCourseTitle( code ){
            let title = '';
            for( let levelTerm in this.courses ){
                this.courses[levelTerm].forEach( course => {
                    if( course.Code === code ){
                        title = course.Title;
                    }
                })
            }
            return title;
        },
        FixTheme(x){
            this.lightTheme=x;
            localStorage.setItem('Theme',x);
        },
        FetchTheme(){
            if(localStorage.getItem('Theme')!==undefined){
                if(localStorage.getItem('Theme')==='true'){
                this.FixTheme(true)}else{this.FixTheme(false);}   
            }else{this.FixTheme(false)}
        }
    },
    computed:{
        FilteredSugg(){
            let sugg = []
            if(this.searchedKey!==''){sugg = this.suggestions.filter(key=>key.toLowerCase().includes(this.searchedKey.toLowerCase()))}
            return sugg
        }
    }
}
</script>
<style lang="scss" scoped>
.input-group{
    width: 24rem;
    margin: 0 auto;
    .form-control,
    .btn-outline-secondary{
        background-color: transparent;
        border-color: #313131;
        color: #bdbdbd;
    }
}
.light-colors{
    .form-control,
    .btn-outline-secondary{
        background-color: transparent;
        border-color: #bdbdbd;
        color: #313131;
    }
}
</style>
