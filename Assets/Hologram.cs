using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hologram : MonoBehaviour
{
    public GameObject plane;

    public Vector3 bounds = Vector3.one;
    [Range(1, 1000)]
    public int subdivisions = 10;

    private List<GameObject> planes;

    // Start is called before the first frame update
    void Start()
    {
        planes = new List<GameObject>();
        DrawPlanes();
    }

    // Update is called once per frame
    void Update()
    {
          
    }

    void DestroyPlanes() {
        foreach (GameObject go in planes) {
            DestroyImmediate(go);
        }
    }

    void DrawPlanes() {
        Vector3 pos = transform.position;
        Vector3 min = pos - bounds;
        Vector3 max = pos + bounds;

        // float xmin = pos.x - bounds.x;
        // float xmax = pos.x + bounds.x;
        // float ymin = pos.y - bounds.y;
        // float ymax = pos.y + bounds.y;
        // float zmin = pos.z - bounds.z;
        // float zmax = pos.z + bounds.z;

        Generate(min.x, max.x, Vector3.right, Quaternion.Euler(0, 0, 90));
        Generate(min.y, max.y, Vector3.up, Quaternion.identity);
        Generate(min.z, max.z, Vector3.forward, Quaternion.Euler(90, 0, 0));
    }

    void Generate(float min, float max, Vector3 dir, Quaternion rot) {
        float spacing = Mathf.Abs(2 * Vector3.Dot(bounds, dir)) / subdivisions;
        for (float x = min; x < max; x += spacing)
        {
            Vector3 p = x * dir;
            GameObject go = Instantiate(plane, p, rot);
            planes.Add(go);
        }
    }
}
