<template>
    <div class="SearchFER pt-3 pb-3 mb-2" v-bind:class="{'light-colors':lightTheme}">
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
                                <button @click="SearchByDay()" class="btn btn-outline-dark" type="button">GO</button>
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
                                <button @click="SearchBySlot()" class="btn btn-outline-dark" type="button">GO</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2 pl-1 pr-4">
                        <button type="button" class="btn btn-outline-dark w-100" @click="SearchByDaySlot()">SEARCH</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>

<script>

/** IMPORTS */
import { bus } from "../../../main";
import RoutineSlots from "../../../json/RoutineSlots.json";

/** COMPONENTS */

export default {
    name:'SearchFER',
    data(){
        return{

            /** Booleans */
            lightTheme:false,

            /** Objects */

            /** Arrays */
            days:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],
            slots:RoutineSlots,

            /** Strings */
            selectedSlot:'none',
            selectedDay:'none'
        }
    },
    created(){this.FetchTheme();bus.$on("ThemeChanged",x=>{this.FixTheme(x);
    });},
    methods:{
        SearchByDay(){
            bus.$emit('SearchByDay',this.selectedDay);
        },
        SearchBySlot(){
            bus.$emit('SearchBySlot', this.selectedSlot.split('-')[0]);
        },
        SearchByDaySlot(){
            bus.$emit('SearchByDaySlot', [this.selectedDay,this.selectedSlot.split('-')[0]]);
        },
        FixTheme(x) {
            this.lightTheme = x;
            localStorage.setItem("Theme", x);
        },
        FetchTheme() {
            if (localStorage.getItem("Theme") !== undefined) {
                if (localStorage.getItem("Theme") === "true") {
                    this.FixTheme(true)}else {this.FixTheme(false)}}
            else{this.FixTheme(false);}
        }
    }
}
</script>
<style lang="scss" scoped>

.SearchFER {
    background-color: #191919;
}
.form-control{
    background-color: transparent !important;
    border-color: #32383D;
    color: #9e9e9e;
    option{
        background-color: #191919;
        color: #9e9e9e;
    }
}
.btn-outline-dark{
    color: #9e9e9e;
}

.light-colors{
    background-color: white;
    .form-control{
        border-color: #bdbdbd;
        color: #424242;
        option{
            background-color: white;
            color: #424242;
        }
    }
    .btn-outline-dark{
        border-color: #bdbdbd;
        color: #424242;
    }
    .btn-outline-dark:hover{
        background-color: #e0e0e0;
        color: #424242;
    }
}
</style>
