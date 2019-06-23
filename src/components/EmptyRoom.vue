<template>
    <div class="EmptyRoom">

        <SearchFER/>
        <EmptyByDay v-if="emptyByDay.length !== 0" v-bind:emptyRooms="emptyByDay"/>
        <EmptyBySlot v-if="emptyBySlot.length !== 0" v-bind:emptyRooms="emptyBySlot"/>

        <div class="container">
            <div v-if="emptyDaySlot.length !== 0">
                <div class="card float-left mr-2 mb-2" v-for="(r, i) in emptyDaySlot" v-bind:key="i">
                    <div class="card-body">
                        <p class="card-text">{{r.Room}}</p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</template>

<script>

/** IMPORTS */
import db from "../js/firebaseInit";
import { bus } from "../main";

/** COMPONENTS */
import SearchFER from "../components/subs/SearchFER";
import EmptyByDay from "../components/subs/EmptyByDay";
import EmptyBySlot from "../components/subs/EmptyBySlot";

export default {
    name:'EmptyRoom',
    props:{

    },
    components:{SearchFER,EmptyByDay,EmptyBySlot},
    data(){
        return{

            /** Booleans */

            /** Objects */
            emptyRooms:{},

            /** Arrays */
            emptyBySlot:[],
            emptyByDay:[],
            emptyDaySlot:[],
            
            /** Strings */
            searchedDay:"",
            searchedSlot:""
        }
    },
    created(){
        bus.$on('Routines',data=>{this.FindEmptyRooms(data)});
        bus.$on('SearchByDay',day=>{this.SearchByDay(day)});
        bus.$on('SearchBySlot',slot=>{this.SearchBySlot(slot)});
        bus.$on('SearchByDaySlot',data=>{this.SearchByDaySlot(data[0],data[1])});
    },
    methods:{
        FindEmptyRooms(Routines){
            for( const day in Routines ){
                if( day !== 'Labs' ){
                    for( const slot in Routines[day]){
                        Routines[day][slot].forEach( ro => {
                            if( ro.Room && !ro.Course ){
                                if( this.emptyRooms[day] ){
                                    if( this.emptyRooms[day][slot] ){
                                        this.emptyRooms[day][slot].push(ro);
                                    }else{
                                        this.emptyRooms[day][slot] = [ro];
                                    }
                                }else{
                                    this.emptyRooms[day]={};
                                    this.emptyRooms[day][slot] = [ro];
                                }
                            }
                        })
                    }
                }
            }
        },
        SearchByDaySlot(day, slot){
            this.emptyByDay=[];this.emptyBySlot=[];
            if( day === 'none' && slot !== 'none' ){
                this.SearchBySlot(slot);
            }else if( day !== 'none' && slot === 'none' ){
                this.SearchByDay(day);
            }else{
                this.emptyDaySlot={};
                this.emptyDaySlot = this.emptyRooms[day][slot];
            }
        },
        SearchByDay(day){
            this.emptyBySlot=[];this.emptyDaySlot=[];
            if(day !== 'none' ){
                this.emptyByDay = this.emptyRooms[day];
            }else{
                this.emptyByDay = [];
            }
        },
        SearchBySlot(slot){
            this.emptyByDay=[];this.emptyDaySlot=[];
            if( slot !== 'none' ){
                this.emptyBySlot={};
                for( let day in this.emptyRooms ){
                    if( this.emptyRooms[day] ){
                        this.emptyBySlot[day] = this.emptyRooms[day][slot];
                    }
                }
            }else{
                this.emptyBySlot = [];
            }
        }
    },
    mounted(){

    },
    computed:{

    }
}
</script>
<style lang="scss" scoped>
    .card{
        background-color: #202020;
    }
</style>
