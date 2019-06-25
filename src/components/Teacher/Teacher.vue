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
            <TableView v-if="viewType==='Table' && routineLoaded" v-bind:d="{slots:Slots,Routine:Routine}" />
        </div>
    </div>
</template>
<script>
/* IMPORTS */
import { bus } from "../../main";
import RoutineSlots from "../../json/RoutineSlots.json";
//import EmptyRoutine from "../json/EmptyRoutine.json";

/** COMPONENTS */
import Teachers from "../layouts/Teachers";
import TeacherSuggs from "./subs/TeacherSuggs";
import TableView from "../layouts/TableView"

export default {
    name:"Teacher",
    data(){
        return{

            /** Strings */
            searchedKey:'',viewType:'Table',

            /** Objects */
            Routines:{},courses:{},
            Routine:{Saturday:[],Sunday:[],Monday:[],Tuesday:[],Wednesday:[],Thursday:[],Labs:[]},
            Slots:RoutineSlots,
            
            /** Arrays */
            teachers:[], teacherInfo:[],
            suggestions:[],filteredSugg:[],

            /** Booleans */
            teacherFound:false,routineLoaded:false,
            lightTheme:false,
        }
    },
    components:{Teachers,TeacherSuggs,TableView},
    created(){
        this.FetchTheme();
        bus.$on('ThemeChanged',x=>this.FixTheme(x))
        bus.$on('Routines', x =>{this.Routines=x})
        bus.$on('Courses', x =>{this.courses=x})
        bus.$on('Teachers', x =>{this.teachers=x;this.GenerateSuggestions()})

        bus.$on('SearchedKey',key=>{this.InitTeacherRoutine(key)})
    },
    methods:{
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
        onClickGo(key){
            let oSlots = ["08:30","10:00","11:30","01:00","02:30","04:00"];
            this.ResetRoutine();
            this.GetTeacherInfo(key);
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
                            rout.Title = this.GetCourseTitle(rout.Course.split('(')[0]);
                            this.Routine.Labs.push(rout);
                        }
                    })
                }
                this.RemoveOffDayFromRoutine(day);
            }
            this.routineLoaded=true;
        },
        GetCourseTitle( code ){
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
