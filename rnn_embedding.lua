--BOW 
require 'nn'
require 'nnx'
--require 'cunn'
-- IMP if args is not passed, it takes from global 'args'
return function(args)

    function create_network(args)
        rho = 5 --number of backprop steps
        n_hid = 10
        nIndex = 10000
  
        r = nn.Recurrent(
           n_hid, nn.LookupTable(nIndex, n_hid), 
           nn.Linear(n_hid, n_hid), nn.Rectifier(), --check whether rect or sigmoid
           rho
        )

        rnn = nn.Sequential()
        rnn:add(r)
        mlp:add(nn.Linear(n_hid, n_hid))
        mlp:add(nn.Rectifier())

        local rnn_out = nn.ConcatTable()
        rnn_out:add(nn.Linear(n_hid, args.n_actions))
        rnn_out:add(nn.Linear(n_hid, args.n_objects))

        rnn:add(rnn_out)
        
        if args.gpu >=0 then
            rnn:cuda()
        end    
        return rnn

    end

    return create_network(args)
end