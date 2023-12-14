using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScuffedLiquidShaderReferences : MonoBehaviour
{
    public GameObject bottle;
    public GameObject plane;
    public Material liquid;

    private Vector3 normal;
    private Vector3 pos;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        pos = plane.transform.position;
        normal = plane.transform.up;

        plane.transform.rotation = Quaternion.Euler(new Vector3(bottle.transform.rotation.x, bottle.transform.rotation.y, bottle.transform.rotation.z));

        liquid.SetVector("_PlanePosition", pos);
        liquid.SetVector("_PlaneNormal", normal);
        
    }
}
