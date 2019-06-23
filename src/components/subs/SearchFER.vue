<template>
    <div class="SearchFER mt-3 mb-3">
        <div class="container">
            <form class="form">             
                <div class="row">
                    <div class="col-md-5">
                        <div class="input-group">
                            <select class="form-control" v-model="selectedDay">
                                <option value="none">Select Day</option>
                                <option>{{days[6]}}</option>
                                <option>{{days[0]}}</option>
                                <option>{{days[1]}}</option>
                                <option>{{days[2]}}</option>
                                <option>{{days[3]}}</option>
                                <option>{{days[4]}}</option>
                            </select>
                            <div class="input-group-append">
                                <button @click="SearchByDay()" class="btn btn-dark" type="button">GO</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="input-group">
                            <select class="form-control" v-model="selectedSlot">
                                <option value="none">Select Slot</option>
                                <option>{{slots[0]}}</option>
                                <option>{{slots[1]}}</option>
                                <option>{{slots[2]}}</option>
                                <option>{{slots[3]}}</option>
                                <option>{{slots[4]}}</option>
                                <option>{{slots[5]}}</option>
                            </select>
                            <div class="input-group-append">
                                <button @click="SearchBySlot()" class="btn btn-dark" type="button">GO</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2 pl-1 pr-1">
                        <button type="button" class="btn btn-dark w-100" @click="SearchByDaySlot()">SEARCH</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>

<script>

/** IMPORTS */
import { bus } from "../../main";
import DayOfWeeks from "../../json/DayOfWeeks.json";
import RoutineSlots from "../../json/RoutineSlots.json";


/** COMPONENTS */

export default {
    name:'SearchFER',
    props:{

    },
    components:{
        
    },
    data(){
        return{

            /** Booleans */

            /** Objects */

            /** Arrays */
            days:DayOfWeeks,
            slots:RoutineSlots,

            /** Strings */
            selectedSlot:'none',
            selectedDay:'none'
        }
    },
    created(){

    },
    methods:{
        SearchByDay(){
            bus.$emit('SearchByDay',this.selectedDay);
        },
        SearchBySlot(){
            bus.$emit('SearchBySlot', this.selectedSlot.split('-')[0]);
        },
        SearchByDaySlot(){
            bus.$emit('SearchByDaySlot', [this.selectedDay,this.selectedSlot.split('-')[0]]);
        }
    },
    mounted(){

    },
    computed:{

    }
}
</script>
<style lang="scss" scoped>

    .form-control{
        background-color: #00000000;
        border-color: #32383D;
    }
</style>
