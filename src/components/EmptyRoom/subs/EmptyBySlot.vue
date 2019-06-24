<template>
    <div class="EmptyBySlot pb-2" v-bind:class="{'light-colors':lightTheme}">
        <div class="container">
            <div class="row">
                <div class="col-md-2 p-1 pl-2">
                    <ul class="list-group">
                        <li class="list-group-item active text-center">Saturday</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['Saturday']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md-2 p-1">
                    <ul class="list-group">
                        <li class="list-group-item active text-center">Sunday</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['Sunday']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md-2 p-1">
                    <ul class="list-group">
                        <li class="list-group-item active text-center">Monday</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['Monday']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md-2 p-1">
                    <ul class="list-group">
                        <li class="list-group-item active text-center">Tuesday</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['Tuesday']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md-2 p-1">
                    <ul class="list-group">
                        <li class="list-group-item active text-center">Wednesday</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['Wednesday']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md-2 p-1">
                    <ul class="list-group">
                        <li class="list-group-item active text-center">Thursday</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['Thursday']" v-bind:key="index">
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
    name:'EmptyBySlot',
    props:{
        emptyRooms:{}
    },
    components:{
        
    },
    data(){
        return{

            /** Booleans */
            lightTheme:false
        }
    },
    created(){
        this.FetchTheme();
    },
    methods:{
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
.EmptyBySlot{
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

.light-colors{
    .list-group-item{
        background-color: white;
        color: #313131
    }
    .list-group-item.active{
        color: white ;
        background-color: #009688;
        border-color: #009688;
    }
}

</style>
