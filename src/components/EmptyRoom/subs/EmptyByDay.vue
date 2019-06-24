<template>
    <div class="EmptyByDay pb-2" v-bind:class="{'light-colors':lightTheme}">
        <div class="container">
            <div class="row">
                <div class="col-md p-1 pl-2" v-if="emptyRooms['08:30']">
                    <ul class="list-group">
                        <li class="list-group-item active text-center">08:30-10:00</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['08:30']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md p-1" v-if="emptyRooms['10:00']">
                    <ul class="list-group text-center grey-8">
                        <li class="list-group-item active text-center">10:00-11:30</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['10:00']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md p-1" v-if="emptyRooms['11:30']">
                    <ul class="list-group text-center grey-8">
                        <li class="list-group-item active text-center">11:30-01:00</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['11:30']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md p-1" v-if="emptyRooms['01:00']">
                    <ul class="list-group text-center grey-8">
                        <li class="list-group-item active text-center">01:00-02:30</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['01:00']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md p-1" v-if="emptyRooms['02:30']">
                    <ul class="list-group text-center grey-8">
                        <li class="list-group-item active text-center">02:30-04:00</li>
                        <li class="list-group-item text-center grey-6" v-for="(slot, index) in emptyRooms['02:30']" v-bind:key="index">
                            {{slot.Room}}
                        </li>
                    </ul>
                </div>
                <div class="col-md p-1 pr-2" v-if="emptyRooms['04:00']">
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

export default {
    name:'EmptyByDay',
    props:{
        emptyRooms:{}
    },
    data(){
        return{
            /** Booleans */
            lightTheme:false
        }
    },
    created(){
        this.FetchTheme()
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
