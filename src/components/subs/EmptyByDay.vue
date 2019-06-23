<template>
    <div class="EmptyByDay pb-2">
        <div class="container">
            <div class="row">
                <div class="col-md-2 p-1 pl-2">
                    <ul class="list-group">
                        <li class="list-group-item active text-center">08:30-10:00</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['08:30']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md-2 p-1">
                    <ul class="list-group text-center grey-8">
                        <li class="list-group-item active text-center">10:00-11:30</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['10:00']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md-2 p-1">
                    <ul class="list-group text-center grey-8">
                        <li class="list-group-item active text-center">11:30-01:00</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['11:30']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md-2 p-1">
                    <ul class="list-group text-center grey-8">
                        <li class="list-group-item active text-center">01:00-02:30</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['01:00']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md-2 p-1">
                    <ul class="list-group text-center grey-8">
                        <li class="list-group-item active text-center">02:30-04:00</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['02:30']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md-2 p-1 pr-2">
                    <ul class="list-group text-center grey-8">
                        <li class="list-group-item active text-center">04:00-05:30</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['04:00']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</template>

<script>

/** IMPORTS */

/** COMPONENTS */

export default {
    name:'EmptyByDay',
    props:{
        emptyRooms:{}
    },
    components:{
        
    },
    data(){
        return{

            /** Booleans */

            /** Objects */

            /** Arrays */

            /** Strings */
        }
    },
    created(){

    },
    methods:{

    },
    mounted(){

    },
    computed:{

    }
}
</script>
<style lang="scss" scoped>
    .EmptyByDay{
        height: 100%;
        overflow: auto;
        box-sizing: border-box;
    }
    .list-group-item.active{
        background-color: #009688;
        border-color: #009688;
    }
    .list-group-item{
        background-color: #191919;
    }
</style>
