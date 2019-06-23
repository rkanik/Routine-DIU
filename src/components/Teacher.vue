<template>
    <div id="Teacher">
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

            <table v-if="viewType=='Table'">
                <thead>
                    <tr v-if="Routine.Saturday.length > 0 || Routine.Sunday.length > 0 || Routine.Monday.length > 0 ||
                        Routine.Tuesday.length > 0 || Routine.Wednesday.length > 0 || Routine.Thursday.length > 0">
                        <th>Day/Time</th><th>{{Slots[0]}}</th><th>{{Slots[1]}}</th><th>{{Slots[2]}}</th>
                        <th>{{Slots[3]}}</th><th>{{Slots[4]}}</th><th>{{Slots[5]}}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="Routine.Saturday.length > 0">
                        <th>Saturday</th>
                        <td v-for="el in Routine.Saturday" v-bind:key="el.Time">
                            <p>{{el.Course}}</p>
                            <p>{{el.Room}}</p>
                        </td>
                    </tr>
                    <tr v-if="Routine.Sunday.length > 0">
                        <th>Sunday</th>
                        <td v-for="el in Routine.Sunday" v-bind:key="el.Time">
                            <p>{{el.Course}}</p>
                            <p>{{el.Room}}</p>
                        </td>
                    </tr>
                    <tr v-if="Routine.Monday.length > 0">
                        <th>Monday</th>
                        <td v-for="el in Routine.Monday" v-bind:key="el.Time">
                            <p>{{el.Course}}</p>
                            <p>{{el.Room}}</p>
                        </td>
                    </tr>
                    <tr v-if="Routine.Tuesday.length > 0">
                        <th>Tuesday</th>
                        <td v-for="el in Routine.Tuesday" v-bind:key="el.Time">
                            <p>{{el.Course}}</p>
                            <p>{{el.Room}}</p>
                        </td>
                    </tr>
                    <tr v-if="Routine.Wednesday.length > 0">
                        <th>Wednesday</th>
                        <td v-for="el in Routine.Wednesday" v-bind:key="el.Time">
                            <p>{{el.Course}}</p>
                            <p>{{el.Room}}</p>
                        </td>
                    </tr>
                    <tr v-if="Routine.Thursday.length > 0">
                        <th>Thursday</th>
                        <td v-for="el in Routine.Thursday" v-bind:key="el.Time">
                            <p>{{el.Course}}</p>
                            <p>{{el.Room}}</p>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div v-if="Routine.Labs.length > 0">
                <div class="card" v-for="el in Routine.Labs" v-bind:key="el.Time">
                    <div class="card-body row">
                        <div class="col-md-3">
                            <label class="text-accent">Course title</label>
                            <p class="card-title">{{el.Title}}</p>
                        </div>
                        <div class="col-md-2">
                            <label class="text-accent">Day</label>
                            <p class="card-title">{{el.Day}}</p>
                        </div>
                        <div class="col-md-2">
                            <label class="text-accent">Time</label>
                            <p class="card-title">{{el.Time}}</p>
                        </div>
                        <div class="col-md-2">
                            <label class="text-accent">Teacher</label>
                            <p class="card-title">{{el.Teacher}}</p>
                        </div>
                        <div class="col-md">
                            <label class="text-accent">Room</label>
                            <p class="card-title">{{el.Room}}</p>
                        </div>
                        <div class="col-md">
                            <label class="text-accent">Code</label>
                            <p class="card-title">{{el.Course}}</p>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</template>
<script>
/* IMPORTS */
import { bus } from "../main";
import RoutineSlots from "../json/RoutineSlots.json";
//import EmptyRoutine from "../json/EmptyRoutine.json";

/** COMPONENTS */
import Teachers from "./subs/Teachers";
import TeacherSuggs from "./subs/TeacherSuggs";

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
            teacherFound:false
        }
    },
    components:{Teachers,TeacherSuggs},
    created(){
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
            Object.keys(this.Routines).forEach( day => {
                if( day !== 'Labs' ){
                    Object.keys(this.Routines[day]).forEach( slot => {
                        this.Routines[day][slot].forEach( routine => {
                            if( routine.Teacher === key.toUpperCase() ){
                                let ind = oSlots.indexOf(slot);
                                this.Routine[day].splice(ind,1,routine);
                            }
                        })
                    })
                }
                else{
                    this.Routines.Labs.forEach( rout => {
                        if( rout.Teacher === key.toUpperCase() ){
                            rout.Title = this.GetCourseTitle(rout.Course.split('(')[0]);
                            this.Routine.Labs.push(rout);
                        }
                    })
                }
                this.RemoveOffDayFromRoutine(day);
            })
        },
        GetCourseTitle( code ){
            let title = '';
            Object.keys(this.courses).forEach( levelTerm => {
                this.courses[levelTerm].forEach( course => {
                    if( course.Code === code ){
                        title = course.Title;
                    }
                })
            });
            return title;
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
    #Teacher{
        width: 100%;
        height: 100%;
        padding-top: 1rem;
    }
    .input-group{
        width: 24rem;
        margin: 0 auto;
        .form-control,
        .btn-outine-secondary{
            background-color: transparent;
            border-color: #424242;
        }
    }
    .btn-outline-secondary{
        background-color: transparent;
        border-color: #424242;
    }
    table{
    width: 100%;
    background-color: #191919;
    margin-bottom: 2rem;
    border-collapse: collapse;
    thead{
        tr{
            background-color: #006064;
        }
        th{
            padding: 0.4rem 0 0.4rem 1rem;
            font-size: 1em;
            font-weight: 500;
            color: #bdbdbd;
            border-right: 1px solid #313131;
        }
        th:last-child{
            border-right-color: #006064;
        }th:first-child{
            border-left: 1px solid #006064;
        }
    }
    tbody{
        tr{
            background-color: #191919;
            //border: 1px solid #161616;
        }
        td,th{
            padding: 0.6rem 0 0.6rem 1rem;
            border: 1px solid #202020;
            p{
                margin: 0 ;
                font-weight: 300;
                font-size: 15px;
            }
        }
    } 
}
    .card{
        background-color: #191919;
        padding: 0 0.5rem;
        margin-bottom: 1rem;
        border: 1px solid #202020;
        .card-title,label{
            margin-bottom: 0;
        }
        label{
            font-size: 0.9em;
        }
    }
</style>
