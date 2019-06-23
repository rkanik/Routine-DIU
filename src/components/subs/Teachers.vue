<template>
    <div class="Teachers" v-bind:class="{'light-colors':lightTheme}">
        <div class="mr-3 ml-3">
            <div class="row p-2">
                <div v-bind:class="{'col-md-12 text-center':teachers.length==1}" class="col-md-4 p-0 pr-2 mb-2" v-for="t in teachers" v-bind:key="t.Initial">
                    <div class="box bg-grey-9 p-3 h-100 rounded">
                        <h5 class="grey-5"><span class="grey-6">Name:</span> {{t.Name}}</h5>
                        <p class="grey-5"><span class="grey-6">Initial:</span> {{t.Initial}}</p>
                        <p class="grey-5"><span class="grey-6">Designation:</span> {{t.Designation}}</p>
                        <p class="grey-5"><span class="grey-6">Email:</span> {{t.Email}}</p>
                        <p class="grey-5"><span class="grey-6">Phone:</span> {{t.Phone}}</p>
                        <a class="teal-6" v-if="t.Webpage" :href=t.Webpage target="_blank">See profile on diu website</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>

/** IMPORTS */
import { bus } from "../../main";

/** COMPONENTS */

export default {
    name:'',
    props:{
        teachers:Array
    },
    components:{
        
    },
    data(){
        return{

            /** Booleans */
            lightTheme:false,

            /** Objects */

            /** Arrays */

            /** Strings */
        }
    },
    created(){
        this.FetchTheme()
        bus.$on('ThemeChanged', x=>this.FixTheme(x));
    },
    methods:{
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
    mounted(){},
    computed:{}
}
</script>
<style lang="scss" scoped>
.box{
    box-shadow: 0 0 3px rgba(0,0,0,0.1), 0 1px 2px rgba(0,0,0,0.2);
    p{
        margin: 0;
    }
}

.light-colors{
    .box{
        box-shadow: 0 0 3px rgba(0,0,0,0.1), 0 1px 2px rgba(0,0,0,0.2);
        background-color: white;
        h5,p{
            color: #313131;
        }
    }
}
</style>
