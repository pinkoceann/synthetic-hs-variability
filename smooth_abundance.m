function A = smooth_abundance(sigma2,H,W,P,cutoff,position)
%-G�n�ration de matrices d'abondance synth�tiques comportant une forte 
% corr�lation spatiale (smoothness).
%%-----------------------------------------------------------------------%%
%-Arguments :
%     H    : hauteur de la carte d'abondance g�n�r�e;
%     W    : largeur   --------------------------   ;
%     P    : nombre d'endmembers consid�r�s;
%   cutoff : somme max. des abondances par pixel (absence de pixel pur);
%   sigma2 : r�gle la rapidit� � laquelle les abondances d�croissent;
%   method : positions des pixels purs al�atoires ou fix�es
%
%-Sortie : 
%   A : matrice de format (P|H*W) contenant les cartes d'abondances
%       g�n�r�es pour chacun des endmembers.
%%-----------------------------------------------------------------------%%
A = zeros(H,W,P);
for k = 1:P-1
    for i = 1:H
        for j = 1:W
            A(i,j,k) = cutoff*exp( -(norm([i,j] - position(k,:),2)^2)/(2*sigma2));
        end
    end
end

A(:,:,P) = ones(H,W) - sum(A(:,:,1:P-1),3);
id  = (A > cutoff);
A(id) = cutoff;
id = (A <= 0);
A(id) = 0;

s = sum(A,3);
A = A./s(:,:,ones(P,1));

A = (reshape(permute(A,[2 1 3]),H*W,P))'; % remise des �l�ments dans l'ordre (li� au choix de l'ordre lexicographique)

end