<template>
    <div class="StudOverview pt-3">
        <p class="mb-1 label teal-6">OVERVIEW OF SIGNED STUDENTS</p>
        <div class="container">
            <div class="row">
                <div class="col-md">
                    <div class="box p-2 btlr">
                        <div class="circle br-grn-5 mt-2">
                            <p class="text-center grn-5">{{data.totalUser}}</p>
                        </div>
                        <p class="label mb-1 mt-2 text-center grey-6">Total user</p>
                    </div>
                </div>
                <div class="col-md">
                    <div class="box p-2">
                        <div class="circle mt-2 br-teal-4">
                            <p class="text-center teal-4">{{data.visitedToday}}</p>
                        </div>
                        <!-- <div class="per-box mt-3">
                            <div class="per-base w-100">
                                <div class="per-line">
                                    <div class="per-circle">
                                        <p class="per-text">99%</p>
                                    </div>
                                </div>
                            </div>
                        </div> -->
                        <p class="label mb-1 mt-2 text-center grey-6">Visited today</p>
                    </div>
                </div>
                <div class="col-md">
                    <div class="box p-2">
                        <div class="circle mt-2 br-orng-7">
                            <p class="text-center orng-7">{{data.signedToday}}</p>
                        </div>
                        <p class="label mb-1 mt-2 text-center grey-6">Signed in today</p>
                    </div>
                </div>
                <div class="col-md">
                    <div class="box p-2">
                        <div class="circle mt-2 br-blu-5">
                            <p class="text-center blu-5">{{data.visitedLastWeek}}</p>
                        </div>
                        <p class="label mb-1 mt-2 text-center grey-6">Visited last week</p>
                    </div>
                </div>
                <div class="col-md">
                    <div class="box p-2 btrr">
                        <div class="circle mt-2 br-pnk-5">
                            <p class="text-center pnk-5">{{data.signedLastWeek}}</p>
                        </div>
                        <p class="label mb-1 mt-2 text-center grey-6">Signed last week</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
export default {
    name:'StudOverview',
    props:{
        data:{}
    }
}
</script>
<style lang="scss" scoped>
.label{
    text-transform: uppercase;
    font-size: 0.8em;letter-spacing: 1px;
}
.col-md{
    padding: 0;
    border-left: 1px solid #191919;
    .box{
        position: relative;
        width: 100%;height: 100%;
        background-color: #202020;
        .label{
            text-transform: uppercase;
            font-size: 0.8em;letter-spacing: 1px;
        }
    }
    .btrr{
        border-top-right-radius: 6px;
        border-bottom-right-radius: 6px;
    }
    .btlr{
        border-top-left-radius: 6px;
        border-bottom-left-radius: 6px;
    }
    .percentage{
        position: absolute;
        top: 1rem;right: 1rem;
    }
}
.col-md:first-child{
    border-left: none;
}
.circle{
    display: block;
    margin: 0 auto;
    width: 5rem;height: 5rem;
    border: 4px solid;
    border-radius: 50%;
    position: relative;
    p{
        font-size: 1.5em;
        font-weight: 500;
        position: absolute;
        top: 50%;left: 50%;
        transform: translate(-50%, -50%);
    }
}
.br-teal-4{
    border-color: #26a69a;
}
.br-orng-7{
    border-color: #f57c00;
}
.br-blu-5{
    border-color: #2196f3;
}
.br-pnk-5{
    border-color: #e91e63;
}
.br-grn-5{
    border-color: #4caf50;
}
</style>
