# addLogic.R
# copyright 2015-2016, openreliability.org
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

addLogic<-function(DF, type, at, reversible_cond=FALSE, cond_first=TRUE, human_pbf=-1, 
		name="", name2="", description="")  {

	if(!test.ftree(DF)) stop("first argument must be a fault tree")

	tp<-switch(type,
		or = 10,
		and = 11,
		inhibit=12,
		alarm=13,
		cond=14,
		conditional =14,
		priority=14,
		comb=15,
		stop("gate type not recognized")
	)

	parent<-which(DF$ID== at)
	if(length(parent)==0) {stop("connection reference not valid")}
	thisID<-max(DF$ID)+1
	if(DF$Type[parent]<10) {stop("non-gate connection requested")}

	if(!DF$MOE[parent]==0) {
		stop("connection cannot be made to duplicate nor source of duplication")
	}
	
	if(DF$Type[parent]==15) {
		if(length(which(DF$CParent==at))>0) {
			stop("connection slot not available")
		}
		if(tp!=10) {
			stop("only OR or basic event can connect to comb gate")
		}
	}

	condition=0
	if(DF$Type[parent]>11&& DF$Type[parent]!=15 )  {
		if(length(which(DF$CParent==at))>1)  {
		stop("connection slot not available")
		}
		if( length(which(DF$CParent==at))==0)  {
			if(DF$Cond_Code[parent]<10)  {
				condition=1
			}
		}else{
##  length(which(DF$CParent==at))==1
			if(DF$Cond_Code[parent]>9)  {
				condition=1
			}
		}
	}


## default is non-reversible, so
	reversible=0
	if(reversible_cond==TRUE)  {
		reversible=1
		if(tp!=14) {
			reversible=0
			warning(paste0("reversible_cond entry ignored at gate ",as.character(thisID)))
		}
	}

	## resolve whether condition is first or second child
		cond_second=0
		if(cond_first == FALSE)  {
			cond_second=1
			if(tp<12 || tp>14) {
				cond_second=0
				warning(paste0("cond_first entry ignored at gate ",as.character(thisID)))
				}
		}

		cond_code<-reversible+10*cond_second

	if(tp == 13) {
		if(human_pbf < 0 || human_pbf >1) {
			stop(paste0("alarm gate at ID ", as.character(thisID), " requires human failure probability value"))
		}
	}else{
		if(human_pbf!=-1) {
			human_pbf=-1
			warning(paste0("human failure probability for  non-alarm gate at ID ",as.character(thisID), " has been ignored"))
		}
	}

	Dfrow<-data.frame(
		ID=	thisID	,
		GParent=	at	,
		CParent=	at	,
		Level=	DF$Level[parent]+1	,
		Type=	tp	,
		CFR=	-1	,
		PBF=	-1	,
		CRT=	-1	,
		MOE=	0	,
		PHF_PZ=	human_pbf	,
		Condition=	condition,
		Cond_Code=	cond_code,
		Interval=	-1	,
		Tag_Obj=	""	,
		Name=	name	,
		Name2=	name2	,
		Description=	description	,
		Unused1=	""	,
		Unused2=	""
	)


	DF<-rbind(DF, Dfrow)

	DF
}
