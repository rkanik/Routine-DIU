<template>
    <div class="Students">
        <div class="container">
            <StudOverview v-if="studentsOverview.loaded" v-bind:data="studentsOverview"/>
            <VisitedOverview v-if="visitedOverview.loaded" v-bind:data="visitedOverview"/>
        </div>
        <StudList v-if="studentsLoaded" v-bind:data="studentPaginate"/>
    </div>
</template>

<script>

/** IMPORTS */
import db from "../../js/firebaseInit";
import { bus } from "../../main";

import Students from "../../../data/json/AllStudents.json";

/** COMPONENTS */
import StudOverview from "../admin/StudOverview";
import VisitedOverview from "../admin/VisitedOverview";
import StudList from "../admin/StudList";

export default {
    name:'Students',
    props:{
        
    },
    components:{StudOverview,VisitedOverview,StudList},
    data(){
        return{

            /** Booleans */
            studentsLoaded:false,visitedLoaded:false,

            /** Objects */
            Students:{},
            studentPaginate:{
                pages:{nprev:0,prev:0,current:1,next:2,nnext:3,last:0},
                s:{}
            },
            studentsOverview:{
                loaded:false,totalUser:0,visitedToday:0,signedToday:0,
                visitedLastWeek:0,signedLastWeek:0
            },
            visitedOverview:{
                loaded:false,totalVisitor:0,visitedToday:0,addedToday:0,
                visitedLastWeek:0
            }

            /** Arrays */

            /** Strings */

            /** Numbers */
            
            
        }
    },
    created(){     
        this.FetchAllStudents();this.FetchVisited();
        bus.$on('GetStudentsAt', pageNo => this.GetStudentsAt(pageNo));
    },
    mounted(){
           
    },
    methods:{
        GetDifferenceFromNowInMin(lastVisited){
            return Math.ceil((Math.abs(new Date().getTime()-lastVisited.seconds*1000)) / ( 1000 * 60 ))
        },
        GetVisitedToday(visitors){
            let vT = 0
            visitors.forEach(visitor=>{
                let lvFromNowInMin = this.GetDifferenceFromNowInMin(visitor.last_visited)
                if( lvFromNowInMin<=1440){vT++}
            })
            return vT
        },
        async FetchVisited(){
            let res = await db.collection('UsageHistory').orderBy('last_visited','desc').get()
            let visitors = [];res.forEach( doc => {visitors.push(doc.data())})

            visitors.forEach( visitor => console.log('ip:'+visitor.ip+'<->'+'last: '+new Date(visitor.last_visited.seconds*1000)))

            this.visitedOverview.totalVisitor = visitors.length
            visitors.forEach( visitor => {
                let lvFromNowInMin = this.GetDifferenceFromNowInMin(visitor.last_visited)
                if( lvFromNowInMin <= 1440 ){ this.visitedOverview.visitedToday++ }
                if( lvFromNowInMin <=10080 ){ this.visitedOverview.visitedLastWeek++}
                if(this.GetDifferenceFromNowInMin(visitor.first_visited) <= 1440 ){
                    this.visitedOverview.addedToday++}
            })
            this.visitedOverview.loaded=true
        },
        GetStudentsAt(pageNo){
            if( pageNo !== this.studentPaginate.pages.current ){
                let startIndex = ((pageNo*10)-10);
                let endIndex = pageNo*10 ;
                let students = this.Students.slice(startIndex,endIndex);
                this.studentPaginate.s = students;
                this.FixIndexOfPaginates(this.studentPaginate.s , startIndex+1);

                this.studentPaginate.pages.nprev = pageNo-2;
                this.studentPaginate.pages.prev = pageNo-1;
                this.studentPaginate.pages.current = pageNo;
                this.studentPaginate.pages.next = pageNo+1;
                this.studentPaginate.pages.nnext = pageNo+2;
            }
        },
        SortByLastVisited(){
            this.Students.sort( (a, b) => {
                let dateA = new Date(a.LastVisited), dateB = new Date(b.LastVisited);
                return dateB - dateA ;
            })
        },
        FixLastVisited(){
            let now = new Date().getTime();
            let visitedLastWeek = 0, visitedToday = 0 ;

            this.Students.forEach( stud => {
                let last = stud.LastVisited.seconds*1000;
                let diffMin = Math.ceil((Math.abs(now-last)) / (1000 * 60 ));
                if( diffMin <= 10080 ){
                    visitedLastWeek++;
                }

                if( diffMin > 2880 ){
                    let diffDay = Math.ceil( diffMin / 2880 )
                    stud.LastVisited = diffDay+" days ago";
                }
                else if(diffMin > 1440){
                    let diffDay = Math.floor( diffMin / 1440 );
                    let diffHour = Math.ceil( (diffMin - 1440) / 60 );
                    stud.LastVisited = diffDay+"day "+diffHour+"h ago";

                }else if( diffMin > 59 ){
                    visitedToday++;
                    let hour = Math.floor(diffMin / 60) ;
                    let min = diffMin - (hour * 60) ;
                    stud.LastVisited = hour+"h "+min+"m ago";
                }else{
                    visitedToday++;
                    stud.LastVisited = diffMin+"min ago";
                }

            });
            this.studentsOverview.visitedToday = visitedToday ;
            this.studentsOverview.visitedLastWeek = visitedLastWeek ;
        },
        CountSignedToday(){
            let signedToday = 0,signedLastWeek=0;
            this.Students.forEach( st => {
                let stCreated = st.CreatedAt.seconds*1000;
                let today = new Date().getTime();
                let diffDay = Math.ceil((Math.abs(stCreated-today)) / (1000 * 60 * 60 * 24 ));
                if( new Date(stCreated).toDateString() === new Date(today).toDateString() ){
                    signedToday++;
                }
                if( diffDay <= 7 ){
                    signedLastWeek++;
                }
            })
            this.studentsOverview.signedLastWeek = signedLastWeek;
            this.studentsOverview.signedToday = signedToday; 
        },
        FixIndexOfPaginates(data, start){
            data.forEach( el => {
                el.index = start;
                start++;
            })
        },
        async FetchAllStudents(){
            bus.$emit('StartLoader');
            this.Students=[];this.loading=true;

            let res = await db.collection('Students').orderBy('LastVisited','desc').get();
            res.forEach(stud=>{this.Students.push(stud.data())})
         
            //this.SortByLastVisited();
            this.FixLastVisited();
            this.CountSignedToday();
            this.studentsOverview.totalUser = this.Students.length;
            this.studentPaginate.s = this.Students.slice(0,10);
            this.studentPaginate.pages.last = Math.ceil(this.Students.length/10);
            this.FixIndexOfPaginates(this.studentPaginate.s,1);
            this.studentsLoaded=true;
            bus.$emit('StopLoader');
            this.studentsOverview.loaded=true;
        },
    }
}
</script>
<style lang="scss" scoped>
    .Students{
        padding-bottom: 1rem;
        height: 100%;
        overflow: auto;
    }
    .table{
        border: 1px solid #fafafa;
        border-collapse: collapse;
        tbody tr:nth-child(odd){
            background-color: #e0f2f1;
        }
    }
</style>
