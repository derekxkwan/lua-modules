--Derek Kwan 2016, released under gpl v2.0

local heap = {}

heapsize = 0
heapdata = {}
heaptype = 0 --0=min, 1=max

--local functions
local heapinv = function(idx1, idx2)
    --return 1 if passes heapinvariant, 0 if fails
    --pass child idx as idx1, parent idx as idx2
    local retval
    local elt1
    local elt2
    --bounds checking
    if idx1 > heapsize or idx2 > heapsize then
        return nil
    else
        --else get vals at indices
        elt1 = heapdata[idx1]
        elt2 = heapdata[idx2]
    end
    local cmp1 = elt1
    local cmp2 = elt2
    --if elt1 and elt2 are not numbers or strings, change them to compare the first elt
    if type(elt1) ~= "number" and type(elt1) ~= "string" then
        cmp1 = elt1[1]
    end
    if type(elt2) ~= "number" and type(elt1) ~= "string" then
        cmp2 = elt2[1]
    end

    if heaptype == 0 then
        --minheap, children must be larger so return true if larger 
        if cmp1 >= cmp2 then
            retval = true
        else
            retval = false
        end
    else
        --maxheap, children must be smaller than parent so return true if smaller
        if cmp1 <= cmp2 then
            retval = true
        else
            retval = false
        end
    end
    return retval
end

local heapeq = function(elt1, elt2)
    --equality of two elements
    local retval = true
    --if two diff types, can't be compared
    if type(elt1) ~= type(elt2) then
        return false
    end
    --if type is number or string, do normal compare
    if type(elt1) == "number" or type(elt1) == "string" then
        retval = elt1 == elt2
    else
        --if lengths aren't equal, can't be compared
        if #elt1 ~= #elt2 then
            return false
        else
            --do elt by elt comparison
            for curidx=1,#elt1 do
                if elt1[curidx] ~= elt2[curidx] then
                    retval = false
                end
            end
        end
    end
    return retval
end

--global functions

heap.dump = function()
    --prints indices and values of data
    for i,v in pairs(heapdata) do
        if type(v) == "number" or type(v) == "string" then
            print(i,v)
        else
            local toprint = "{"
            for pidx,pval in pairs(v) do
                toprint = toprint..tostring(pval)
                if pidx ~= #v then
                    toprint = toprint..","
                end
            end
            toprint = toprint .."}"
            print(i,toprint)
        end
    end
end

heap.search = function(tofind)
    --returns index of first instance of tofind, if can't find then returns nil
    local retidx = nil
    for i,v in pairs(heapdata) do
        if heapeq(v,tofind) == true then
            retidx = i
            break
        end
    end
    return retidx
end
    
heap.push = function(elt)
    --increment size than set pos to size since 1-indexed
    heapsize = heapsize + 1
    local pos = heapsize

    heapdata[pos] = elt
    
    --keep comparing to parents which is floor(pos/2)
    --if child fails heapinv with parent, swap and continue

    while (pos/2) >= 1 do
        local pidx = math.floor(pos/2) --parent idx
        if heapinv(pos, pidx) == true then
            break
        else
            heapdata[pos],heapdata[pidx] = heapdata[pidx],heapdata[pos]
            pos = pidx
        end
    end
end

heap.heapify = function(arr,htype)
    heapdata = {}
    heapsize = 0
    -- htype should be "min" or "max" but just check for max, else default to min
    if htype == "max" then
        heaptype = 1
    else
        heaptype = 0
    end
 
    for idx,elt in pairs(arr) do
        heap.push(elt)
    end
end

heap.peek = function()
    if heapsize < 1 then
        return nil
    else
        return heapdata[1]
    end
end

heap.delidx = function(idx)
    --delete elt by index
    --bounds checking
    if idx < 1 or idx > heapsize then
        return
    end
    --make last elt  elt to be replaced and percolate down
    heapdata[idx] = heapdata[heapsize]
    table.remove(heapdata, heapsize)
    heapsize = heapsize - 1 --decrement

    local pos = 1 --position of element to percolate down
    
    --percolate down
    while (pos*2) <= heapsize do
        --if there's at least a left child
        local posrep = pos*2 --position to replace
        if (posrep + 1)<=heapsize then
            --if there's a right child
            --need to find child that gives best change of satisfying heapinv
            --if child1 satisfies heapinv with child2, child1 could be child of child2
            --so then swap with child2 instead of child1
            if heapinv(posrep,posrep+1) == true then
                posrep = posrep + 1
            end
        end
        if heapinv(pos, posrep) == true then
            heapdata[pos],heapdata[posrep] = heapdata[posrep],heapdata[pos]
            pos = posrep
        else
            break
        end
    end
end

heap.delelt = function(elt)
    --delete by element
    local idx = heap.search(elt)
    heap.delidx(idx)
end

heap.pop = function()
    local retval = heap.peek()
    if heapsize < 1 then
        return nil
    elseif heapsize == 1 then
        heapdata = {}
        heapsize = 0
    else
        heap.delete(1)
    end
    return retval
end

heap.heapmerge = function(heap2)
    for idx,elt in pairs(heap2.data) do
        heap.push(elt)
    end
end

heap.reset = function()
    heapdata = {}
    heapsize = 0
end

--setters/getters
heap.getsize = function()
    return heapsize
end

heap.gettype = function()
    local retstr
    if heaptype == 0 then
        retstr = "min"
    else
        retstr = "max"
    end
    return retstr
end

heap.settype = function(htype)
    --check if equal to old type, if not reheapify
    local curtype = heap.gettype()
    if curtype ~= htype then
        local olddata = heapdata
        heap.reset()
        heap.heapify(olddata,htype)
    end
end

return heap
