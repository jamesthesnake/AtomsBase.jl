using AtomsBase

function make_supercell(system::AbstractSystem{<: AbstractAtom}, repeat::Tuple{<:Integer, <:Integer, <:Integer})
    # TODO This destroys structure as it only works for SimpleAtomicSystem objects
    #      ... should ideally be made that it works for all AbstractSystem objects

    newcell = [r * system.cell[i] for (i, r) in enumerate(repeat)]
    @assert n_dimensions(system) == 3
    newparticles = SimpleAtom{3}[]
    for part in system
        for i in 1:repeat[1], j in 1:repeat[2], k in 1:repeat[3]
            shift = (i-1) * get_cell(system)[1] + (j-1) * get_cell(system)[2] + (k-1) * get_cell(system)[3]
            push!(newparticles, SimpleAtom{3}(shift + get_position(part), get_atomic_symbol(part)))
        end
    end
    SimpleAtomicSystem{3}(newcell, get_boundary_conditions(system), newparticles)
end
